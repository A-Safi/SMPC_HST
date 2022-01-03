%% figures
h1=figure(1);
ax(1)=subplot(1,2,1);
height=8; width=17;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
if ~exist('plot_dovom','var')
    plot(time(1:end-1),x_desire(1:end-1,2:6),'g:','LineWidth' , 1.1);hold on;grid on
end
for i=2:ln
    plot(time,x(1:end,i),color,'LineWidth' , 1.1);hold on;grid on
end
% legend('\itx_1_2','\itx_2_3','\itx_3_4','\itx_4_5','\itx_5_6','\itx^d^e^s^i^r^e_r_e_l_a_t_i_v_e','FontName','Times New Roman','FontSize',10)
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$x_{i,i-1(m)}$','Interpreter','latex')
title('$Reletive Displacement$','Interpreter','latex')
xlim([0 tf_display])

ax(2)=subplot(1,2,2);
height=8; width=17;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
if ~exist('plot_dovom')
    plot([0 time(end)],[0 0],'g:','LineWidth' , 1.1);grid on;hold on
end
for i=ln+2:2*ln
    plot(time,x(1:end,i),color,'LineWidth' , 1.1);hold on;grid on
end

% legend('\itv_1_2','\itv_2_3','\itv_3_4','\itv_4_5','\itv_5_6','\itv^d^e^s^i^r^e_r_e_l_a_t_i_v_e','FontName','Times New Roman','FontSize',10)
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$v_{i,i-1(m/s)}$','Interpreter','latex')
title('$Reletive Speed$','Interpreter','latex')
xlim([0 tf_display])

h2=figure(2);
axx(1)=subplot(2,1,1);
height=10; width=12;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
v_abs=[x(:,7) x(:,7)+x(:,8) x(:,7)+sum(x(:,8:9),2) x(:,7)+sum(x(:,8:10),2) x(:,7)+sum(x(:,8:11),2) x(:,7)+sum(x(:,8:12),2)];
if ~exist('plot_dovom','var')
    plot(time(1:end-1),x_desire(1:end-1,7),'g:','LineWidth' , 1.1);grid on;hold on
end
for i=1:ln
    plot(time,v_abs,color,'LineWidth' , 1.1);hold on;grid on
end
ylim([0 100])
% legend('\itv_1','\itv_2','\itv_3','\itv_4','\itv_5','\itv_6','\itv^d^e^s^i^r^e','FontName','Times New Roman','FontSize',10)
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$v_i(m/s)$','Interpreter','latex')
title('$Absolute Speed$','Interpreter','latex')
xlim([0 tf_display])

axx(2)=subplot(2,1,2);
height=10; width=12;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
for i=1:ln
    plot(time,u(:,i)/1e3,color,'LineWidth' , 1.1);hold on;grid on
end
% legend('\itu_1','\itu_2','\itu_3','\itu_4','\itu_5','\itu_6','FontName','Times New Roman','FontSize',10)
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$u_i(kN)$','Interpreter','latex')
title('$Inputs$','Interpreter','latex')
xlim([0 tf_display])
ylim([-50 70])

Cost=0;
for i=1:6
    Cost=Cost+trapz(time,u(:,i).^2);
end

figure(4)
subplot(1,2,1)
height=8; width=17;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
plot(time(1:end-1),x_desire(1:end-1,1)-x(1:end-1,1),color,'LineWidth',1.5);grid on
hold on
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$\hat{y}(m)$','Interpreter','latex')
title('$Distance Error$','Interpreter','latex')
xlim([0 tf_display])
subplot(1,2,2)
height=8; width=17;
set( gcf, 'Units', 'centimeters' )
set( gcf, 'Position', [ 10 10 width height ] )
set( gcf, 'PaperUnits', 'centimeters' )
set( gcf, 'PaperSize', [ 21 29.7 ] )
set( gcf, 'PaperPositionMode', 'Manual' )
set( gcf, 'PaperPosition', [ 10 10 width height ] )
plot(time(1:end-1),x_desire(1:end-1,7)-x(1:end-1,7),color,'LineWidth',1.5);grid on
hold on
xlabel('$Time(sec)$','Interpreter','latex')
ylabel('$Velocity(m/s)$','Interpreter','latex')
title('$Speed Error$','Interpreter','latex')
xlim([0 tf_display])