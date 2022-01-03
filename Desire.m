h=0.1; %solution's timestep
tf=970; %solution's endtime
time=(0:h:tf)'; %time's vector
tf_display=tf;

x_front=zeros(length(time),1);
%% Desire velocities
v_end=20;
v_between=80;
v_ref0=v_start*ones(1,length(time(1:180/h)));
v_ref1=linspace(v_start,v_between,length(time(1:120/h)));
v_ref2=v_between*ones(1,length(time(1:180/h)));
v_ref3=linspace(v_between,v_end,length(time(1:120/h)));
v_ref4=v_end*ones(1,length(time(1:370/h+1)));
v_ref=[v_ref0,v_ref1,v_ref2,v_ref3,v_ref4];

x_desire=[x_front ones(length(time),ln-1)*(lkd),v_ref',zeros(length(time),5)];

for i=1:length(time)-1
    x_desire(i+1,1)=x_desire(i,1)+x_desire(i,7)*h;
end

save('Results\desire.mat','x_desire')
