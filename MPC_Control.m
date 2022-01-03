clear;clc
color='b-';
ds=genpath(pwd);
addpath(ds);
yalmip('clear')

%% Parameters of the system.
ln = 6;       % Nulnber of spring-mass elements.
m = 80000;    % Mass of each element.
k = 80000;    % Linear spring coefficient

c0 = 0.01176;
c1 = 0.00077616;
c2 = 0.000016;
vnom = 100;

lk=1.2;   % Free tension
lkd=-1.2; % Desire reletive displacment
b=3.38;   % Width of Train's cars
L=25;     % Length of Train's cars

%% Linearized System
run('sys_lin.m');

%% initial values
v_start=20;
x_init=[0;-lk;-lk;-lk;-lk;-lk;v_start;0;0;0;0;0];
x_MPC(:,1)=x_init;
x_linear(:,1)=x_init;

%% Desire
run('Desire.m')
save('Results\desire.mat','x_desire')

% load('desire.mat');

%% Simulation Time
Ts=0.1;
tf=960; % max simulation time 960sec
time=0:Ts:tf;
tf_display=tf;

%% Discretizing 
sys = ss(A,B,C,[]) ;
sysd = c2d(sys,Ts);
Ad=sysd.A;
Bd=sysd.B;
Cd=sysd.C;

%% 
nx = length(A); % Number of states
nu = size(B,2); % Number of inputs
ny = rank(C);

%% MPC data
N_p = 3;     % prediction Horizon
N_c = 3;     % control Horizon

%% Defining The Optimization Problem
u = sdpvar(repmat(nu,1,N_c),repmat(1,1,N_c));
x = sdpvar(repmat(nx,1,N_p+1),repmat(1,1,N_p+1));
r = sdpvar(repmat(ny,1,N_p+1),repmat(1,1,N_p+1));

constraints = [];
objective = 0;
Q=eye(ny)*1e3;
Q(2:ny/2,2:ny/2)=eye(ny/2-1)*1e5;
Q(1,1)=0.1;
R=eye(nu)*1e-8;
for i = 1:N_p
    objective = objective + (r{i}-C*x{i})'*Q*(r{i}-C*x{i}) + u{i}'*R*u{i};
    constraints = [constraints, x{i+1} == Ad*x{i} + Bd*u{i}+D*Ts];
    constraints = [constraints,-[5;1;1;1;1;1]*100e3<=u{i}<=[1;1;1;1;1;1]*100e3];
    constraints = [constraints,-[lk;lk;lk;lk;lk]-0.2<=x{i}(2:ny/2)<=[lk;lk;lk;lk;lk]+0.1];
end
objective = objective + (C*x{N_p+1}-r{N_p+1})'*Q*(C*x{N_p+1}-r{N_p+1});
parameters_in = {x{1},[r{:}]};
solutions_out = {[u{:}]};

controller = optimizer(constraints, objective,sdpsettings('solver','quadprog'),parameters_in,solutions_out);

%% Simulation
j=1;
for i=1:length(time(1:end))
    if i > j*length(time)/100
        clc
        progres=sprintf('%d%%',floor(100*i/length(time)));
        disp(progres)
        j=j+1;
    end
    input={x_MPC(:,i),x_desire(i:i+N_p,:)'};
    [solutions,diagnostics] = controller{input};
    uu(:,i) = solutions(:,1);%zeros(6,1);%
    %% Linear System
    %     yy(:,i) = Cd*x_linear(:,i);
    %     x_linear(:,i+1) = Ad*x_linear(:,i)+Bd*uu(:,i)+D*Ts;
    
    %% Non-Linear System
    k1=odefunc(x_MPC(:,i),uu(:,i),lk,[m m m m m m],[c0,c1,c2],k);
    k2=odefunc(x_MPC(:,i)+Ts/2*k1,uu(:,i),lk,[m m m m m m],[c0,c1,c2],k);
    k3=odefunc(x_MPC(:,i)+Ts/2*k2,uu(:,i),lk,[m m m m m m],[c0,c1,c2],k);
    k4=odefunc(x_MPC(:,i)+Ts*k3,uu(:,i),lk,[m m m m m m],[c0,c1,c2],k);
    
    yy(:,i) = Cd*x_MPC(:,i);
    x_MPC(:,i+1)=x_MPC(:,i)+Ts/6*(k1+2*k2+2*k3+k4);
    %% Noise
%     x_MPC(7,i+1)=x_MPC(7,i+1)+0.01*randn(1);
%     x_MPC(8:12,i+1)=x_MPC(8:12,i+1)+0.001*randn(5,1);
end

%%
x=x_MPC(:,1:end-1)';
x_desire=x_desire(1:length(time),:);
u=uu';
run('FigurePloterM.m');
rmpath(ds);







