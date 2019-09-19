global tspan

%plotting r_n trajectory
subplot(2,2,1)
plot3(6*10^6*(data(1,1:tspan,1)-data(1,1,6)), ... 
    6*10^6*(data(2,1:tspan,1)-data(2,1,6)), ...
    data(3,1:tspan,1)-data(3,1,6),...
    6*10^6*(data(1,1:tspan,6)-data(1,1,6)),...
    6*10^6*(data(2,1:tspan,6)-data(2,1,6)),...
    data(3,1:tspan,6)-data(3,1,6));
axis equal
title('Filtered trajectory')
ylabel('Distance [m]')
xlabel('Distance [m]')
zlabel('Relative altitude [m]')

% -------- Quality of estimator (Mean of noises) -------- %
x_perf = data(1,1:tspan,1)-data(1,1:tspan,6);
x_perf = x_perf*x_perf';
y_perf = data(2,1:tspan,1)-data(2,1:tspan,6);
y_perf = y_perf*y_perf';
kalman_perf = x_perf+y_perf;
disp('Kalman filter performance (the smaller the better):')
disp(kalman_perf);

subplot(2,2,2)
%plot(t_mem,data(2,:,9)*10^6*6)

plot3(6*10^6*(data(1,1:tspan,11)-data(1,1,6)), ... 
    6*10^6*(data(2,1:tspan,11)-data(2,1,6)), ...
    data(3,1:tspan,11)-data(3,1,6),...
    6*10^6*(data(1,1:tspan,6)-data(1,1,6)),...%+wgn(1,size_t,r_gps_noise^2,'linear'),...
    6*10^6*(data(2,1:tspan,6)-data(2,1,6)),...
    data(3,1:tspan,6) - data(3,1,6));%+wgn(1,size_t,r_gps_noise^2,'linear'));
axis equal

title('GPS trajectory')
ylabel('Distance [m]')
xlabel('Distance [m]')
zlabel('Relative altitude [m]')

x_perf=data(1,1:tspan,11)-data(1,1:tspan,6);
x_perf=x_perf*x_perf';

y_perf=data(2,1:tspan,11)-data(2,1:tspan,6);
y_perf=y_perf*y_perf';

gps_perf=x_perf+y_perf;

disp('GPS navigation filtering performance:')
disp(gps_perf);

subplot(2,2,3)

plot(time(1:tspan),data(3,1:tspan,1))
title('Altitude')
ylabel('Distance [m]')
xlabel('Distance [m]')

subplot(2,2,4)

plot(time(1:tspan),data(3,1:tspan,3))
title('Vertical velocity')
ylabel('Distance [m]')
xlabel('Distance [m]')

% figure; h
% plot(6*10^6*(data(1,:,1)-data(1,1,1)), ... 
%     6*10^6*(data(2,:,1)-data(2,1,1)), ... 
%     6*10^6*(data(1,:,6)-data(1,1,6)),...%+wgn(1,size_t,r_gps_noise^2,'linear'),...
%     6*10^6*(data(2,:,6)-data(2,1,6)));%+wgn(1,size_t,r_gps_noise^2,'linear'));
% }

%{
plot(6*10^6*(data(1,:,1)-data(1,1,6)), ... 
    6*10^6*(data(2,:,1)-data(2,1,6)), ... 
    6*10^6*(data(1,:,6)-data(1,1,6)),...%+wgn(1,size_t,r_gps_noise^2,'linear'),...
    6*10^6*(data(2,:,6)-data(2,1,6)));%+wgn(1,size_t,r_gps_noise^2,'linear'));
%}
%plot(t_mem, data(1,:,12), t_mem, data(1,:,7))

%plot(del_t:del_t:(del_t*size_t),data(1,:,7),...
%    del_t:del_t:(del_t*size_t),data(2,:,7)) 


%plot(t_mem,data(3,:,1)) %looks ok
%plot(t_mem,data4(1,:)) %looks ok
%plot(t_mem,data4(2,:))  %looks ok

