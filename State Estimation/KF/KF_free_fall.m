clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
%% Alleged Falling Time from h_o = 1000 [m] = 14.2857 [sec];

% G_num = [1 1]; G_den = [1 2 10 5 2]; 
% G = tf(G_num, G_den);
% figure(1); step(G)
% figure(2); rlocus(G)

% [A, B, C, D] = tf2ss(G_num, G_den)
% sim('tf_to_state_space')
%%

A = [0 1; 0 0]; B = [0 1]'; C = eye(2); D = [0 0]';

Ts = 0.25;
sys = ss(A,B,C,D,Ts,'StateName',{'Position' 'Velocity'},...
                    'InputName','Force');

                augstate(sys)

%%
x_o = [1000 0]';
N = 100;
KG = zeros(N,1); Est = KG; err_Est = KG; %True_temp = KG;
sig = 1;
Exp = sig*(-1 + 2*rand(N-1,1) );         % Gaussian Distribution
MEA = 72 + Exp;
Est(1) = 60;
% MEA(1) = 75;
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

%% ----------------- Estimation Error and KG ----------------- %
% figure(2); hold on; grid on;
% plot(1:N, err_Est, 'b-', 'LineWidth', 2);
% ind_2(1) = title('Estimation Error and KG');
% ind_2(2) = xlabel('Iteration [$\#$]');
% ind_2(3) = ylabel('Error');
% 
% yyaxis right;
% plot(1:N, KG, 'r-', 'LineWidth', 2);
% ind_2(4) = ylabel('Kalman Gain'); set(gca, 'ycolor', 'r');
% ind_2(5) = legend('Error', 'KG');
% set(ind_2, 'Interpreter', 'latex', 'fontsize', 16 );
