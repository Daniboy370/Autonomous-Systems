clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

dt = 1;                             % Time step size
A = [1 dt; 0 1];                    % State space Matrix
B = [0.5*dt^2 dt]';                 % Control Matrix
M_rank = length(A);                 % Rank of state vector

N = 50;
KG = zeros(N,1); Est = KG; err_Est = KG; %True_temp = KG;

sig = 1.00;                         % Distribution Width
Exp = sig*(-1 + 2*rand(N-1,1) );    % Gaussian Distribution
MEA = 72 + Exp;
Est(1) = 80;
err_MEA(1) = 4;
err_Est(1) = 2;

for i=2:N
    KG(i) = err_Est(i-1)/(err_Est(i-1) + err_MEA );
    Est(i) = Est(i-1) + KG(i)*(MEA(i-1) - Est(i-1));
    err_Est(i) = (1-KG(i))*(err_Est(i-1));
end

%% ------------- True and Estimated Temprature ------------- %
figure(1); hold on; grid on;
plot(1:N, Est, 'b-', 2:N, MEA, 'r--', 'LineWidth', 2.5);
plot(2:N, MEA, 'r-', 'LineWidth', 1);
ind_1(1) = title('True and Estimated Temprature');
ind_1(2) = xlabel('Iteration [$\#$]');
ind_1(3) = ylabel('Temprature [$^\circ$]');
ind_1(4) = legend('Estimated', 'True');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 16 );

figure(2); grid on;
plot(1:N, KG, '-', 'LineWidth', 2);
ind_1(1) = title('Kalman Gain vs. Iteration');
ind_1(2) = xlabel('Iteration [$\#$]');
ind_1(3) = ylabel('KG]');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 16 );
