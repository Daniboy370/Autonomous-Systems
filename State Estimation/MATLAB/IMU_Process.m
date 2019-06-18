%% ---------------------- Data Extraction from IMU ------------------------ %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
load('Trial_acc');  load('Trial_gyro');
t = acc.Time;
%% -------------------- Accelerometer Data Extraction --------------------- %
% acc.Data(1,:) = X_value;
% acc.Data(2,:) = Y_value;
% acc.Data(3,:) = Z_value;
% acc.Time = time;
% ------------------------- Gyro Data Extraction -------------------------- %
% gyro.Data(1,:) = X_value;
% gyro.Data(2,:) = Y_value;
% gyro.Data(3,:) = Z_value;
% gyro.Time = time;

%% ----------------------------- Plot Results ----------------------------- %
figure('rend','painters','pos',[1800 60 900 600]);
grid on; hold on;
% ---------------- Accelerometer Plot ---------------- %
subplot(2,1,1);
plot( t, acc.Data, '-', 'LineWidth', 1.5);
ind(1) = title( '$f_{ib}^b$ vs. Time' );
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('acc. $[m/sec^2]$');
ind(4) = legend('$a_x$', '$a_y$', '$a_z$');
grid on;
% ------------------ Velocity Plot ------------------ %
a_t = acc.Data(3,:);
v_t = cumtrapz(t, acc.Data(3,:)-9.9278);
x_t = cumtrapz(t, v_t);
subplot(2,1,2);
plot( acc.Time, x_t, '-', 'LineWidth', 1.5);
ind(5) = title( '$v_j$ vs. Time' );
ind(6) = xlabel('Time [sec]');
ind(7) = ylabel('Vel. $[m/sec]$');
ind(8) = legend('$v_j$');
grid on;
% ---------------------------------------------------- %
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

%% ---------------------- Plot - Cumulative Integral ---------------------- %
% close all;
figure('rend','painters','pos',[1800 60 900 600]);
grid on; hold on;
% --------------------- Gyro Plot -------------------- %
subplot(2,1,1);
plot(t, gyro.Data, '-', 'LineWidth', 1.5);
ind(1) = title( '${\Omega}_{ib}^b$ vs. Time' );
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('$\omega$ $[rad/sec]$');
ind(4) = legend('$\omega_x$', '$\omega_y$', '$\omega_z$');
grid on;
% -------------------- Theta Plot -------------------- % 
theta = cumtrapz(t(3710:4242), gyro.Data(1,3710:4242) );
subplot(2,1,2);
plot( t(3710:4242), theta, '-', 'LineWidth', 1.5);
ind(5) = title( '$\theta$ vs. Time' );
ind(6) = xlabel('Time [sec]');
ind(7) = ylabel('$\theta$ $[rad]$');
ind(8) = legend('$\theta_j$');
grid on;
% ---------------------------------------------------- %
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);