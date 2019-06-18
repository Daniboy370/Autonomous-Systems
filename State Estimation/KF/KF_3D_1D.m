clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

N = 50;                                    % Total Number of Iterations
dt = 1;                                     % Time step size
phi = [1];                                  % State space Matrix
B = [1]';                                   % Control Matrix
H = [1];                                    % Observation Matrix
M_rank = length(phi);                       % Rank of state vector
sig = 1.00;                                 % Distribution Width
T_true = 72;                                % Real Temprature
% ----------------- Memory Allocation ---------------- %
x_p = [0]';   x_n = [80]';   P_n = eye(M_rank);

% ------------------ Loop Execution ------------------ %
for i = 2:N
    % ------------ Prediction Stage : (_p) ----------- %
    w = 0;
    Q = covariance(0, 1);           % (flag==1) for Off Diagonal
    x_p(:,i-1) = phi*x_n(:,i-1) + B*w;
    P_p(:,:,i-1) = phi*P_n(:,:,i-1)*phi' + Q;
    %     P_p(:,:,i-1) = diag(diag(P_p(:,:,i-1)));  % For diagonal only
    % -------------- Update Stage : (_n) ------------- %
    u = sig*(-1+2*rand);               % Random Noise
    V(i) = T_true + u;                 % Random Process
    R = 1; %covariance(u, 1);           % (flag==1) for Off Diagonal
    KG(:,:,i-1)  = P_p(:,:,i-1)*H'*( H*P_p(:,:,i-1)*H' + R )^-1;
    x_n(:,i) = x_p(:,i-1) +  KG(:,:,i-1)*( V(i) - H*x_p(:,i-1) );
    P_n(:,:,i) = (eye(M_rank) - KG(:,:,i-1))*P_p(:,:,i-1);
    % --------------- Riccati Equation --------------- %
    %     F = phi;    G = B;     P = P_p;
    %     dP(:,i) = F*P + P*F' + G*Q*G' - P*H'*(R^-1)*H*P;
end

%%
hold on; grid on;
plot(1:N-1, x_p(M_rank,1:N-1), 'b-', 1:N,  x_n(M_rank,1:N), 'r--', 'LineWidth', 2);
plot( 1:N-1, V(M_rank,2:N), 'g-',  1:N, T_true*ones(1,N), 'k--', 'LineWidth', 1.5);       % Measurement
ind_1(1) = title('Kalman Filter Implementation');
ind_1(2) = xlabel('Iteration [$\#$]');
ind_1(3) = ylabel('Tempratue [$^\circ$]'); % [$\frac{m}{sec}$]
ind_1(4) = legend('Predicted', 'KF', 'Measured');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 16 );

%%
%     dP(:,i) = F*P(:,i) + P(:,i)*F';% + G*Q*G';
% N = 100;
% KG = zeros(N,1); Est = KG; err_Est = KG; %True_temp = KG;
%
% sig = 1;
% Exp = sig*(-1 + 2*rand(N-1,1) );         % Gaussian Distribution
% MEA = 72 + Exp;
% Est(1) = 60;
% % MEA(1) = 75;
% err_MEA(1) = 4;
% err_Est(1) = 2;
%
%
% for i=2:N
% KG(i) = err_Est(i-1)/(err_Est(i-1) + err_MEA );
% Est(i) = Est(i-1) + KG(i)*(MEA(i-1) - Est(i-1));
% err_Est(i) = (1-KG(i))*(err_Est(i-1));
% end
%
%
% %% ------------- True and Estimated Temprature ------------- %
% figure(1); hold on; grid on;
% plot(1:N, Est, 'b-', 2:N, MEA, 'r--', 'LineWidth', 2.5);
% plot(2:N, MEA, 'r-', 'LineWidth', 1);
% ind_1(1) = title('True and Estimated Temprature');
% ind_1(2) = xlabel('Iteration [$\#$]');
% ind_1(3) = ylabel('Temprature [$^\circ$]');
% ind_1(4) = legend('Estimated', 'True');
% set(ind_1, 'Interpreter', 'latex', 'fontsize', 16 );