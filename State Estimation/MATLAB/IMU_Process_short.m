%% ----------------------------- Plot Results ----------------------------- %
Acc.Time  =  acc.Time(1:683);
Acc.Data  =  acc.Data(1:2,1:683);
Gyro.Data = gyro.Data(3,1:683);

plot(t, ff)
vel = trapz(t, ff)

%% --------------------- Integrate Sensors --------------------- %
close all;
t = Acc.Time;  omg_z = Gyro.Data;
psi_f = trapz(t, omg_z)
psi   = cumtrapz(t, omg_z);
plot(t, omg_z, '-', t, psi, '-', 'LineWidth', 1.5);
grid on;

%%
close all;
t = linspace(-5,5); y = t+3;
I = trapz(t, y)
I_y = cumtrapz(t, y);
plot(t, y, '-', t, I_y, '-');
grid on;

%%

%% ---------------------- Data Extraction from IMU ------------------------ %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
load('Trial_acc');  load('Trial_gyro');
t = acc.Time;

figure('rend','painters','pos',[1800 60 900 600]); hold on;
% ---------------- Accelerometer Plot ---------------- %
subplot(2,1,1);
plot( acc.Time, acc.Data, '-', 'LineWidth', 1.5);
ind(1) = title( '$f_{ib}^b$ vs. Time' );
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('acc. $[m/sec^2]$');
ind(4) = legend('$a_x$', '$a_y$');
grid on;
% --------------------- Gyro Plot -------------------- %
subplot(2,1,2);
plot(acc.Time, gyro.Data, '-', 'LineWidth', 1.5);
ind(5) = title( '${\Omega}_{ib}^b$ vs. Time' );
ind(6) = xlabel('Time [sec]');
ind(7) = ylabel('$\omega$ $[rad/sec]$');
ind(8) = legend('$\omega_z$');
grid on;
% ---------------------------------------------------- %
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);
