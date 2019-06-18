%% ----------------------- State Space Presentation ----------------------- %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
g = 9.81; m = 1; l = 1; tau = 1;

A = [0 1; -g/l 0];      B = [0; tau/(m*l^2)];
C = [1 0];    D = 0;    x0 = [1 1];


%% 
t = (0:100)';
u = sin(t/5);

Q = 0.05;           % Process Noise Covariance
R = 1;              % Sensor  Noise Covariance

[G_num, G_den] = ss2tf(A, B, C, D, 1);
G = tf(G_num, G_den);

N = 1000;    t = linspace(0, 15, N);
lsim(G, ones(1, N), t, x0); 

%% -------------------------- Simulink Execution -------------------------- %
close all;
sim('KF_Pendulum');
vec = Theta.Data;
t = Theta.Time;

% ----------------------------- Plot Results ----------------------------- %
figure(2); grid on; hold on;
plot(t, vec, '-', 'LineWidth', 3);
ind(1) = title( '$r(t)$ vs. Time' );
ind(2) = ylabel('Range [m]');
ind(3) = xlabel('$t_{go}$ [sec]');
ind(4) = legend('$r(t)$', '$r_8(t)$');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

