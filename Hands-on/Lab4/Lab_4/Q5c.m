close all
clc

load('errOdom');
WND = getWND();
figure(1)
plot(WND,err_Odom, 'b', 'linewidth', 2);
hold on
grid on
box on
xlabel('WND');
ylabel('3D Triangulation Error');
set(gca,'FontSize', 16 );
title('3D Triangulation Error Vs. WND','FontSize',20);
