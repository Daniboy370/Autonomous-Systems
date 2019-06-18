clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

tf = 10;                                    % [sec]
dt = 0.01;                                  % Sample rate [Hz]
N = tf/dt;                                  % Total # itertations
t = linspace(0, tf, N);                     % Time Vector
A = [1];                                    % State space Matrix
B = [1]';                                   % Control Matrix
H = [1];                                    % Observation Matrix
M_rank = length(A);                         % Rank of state vector
sig = 1.00;                                 % Distribution Width
T_true = 72;                                % Real Temprature
% ----------------- Memory Allocation ---------------- %
x_p = 0;   x_n = 50;   P_n = eye(M_rank);

% ------------------ Loop Execution ------------------ %
for i = 2:N
    % ------------ Prediction Stage : (_p) ----------- %
    w = 0;
    Q = covariance(0, 1);           % (flag==1) for Off Diagonal
    x_p(:,i-1) = A*x_n(:,i-1) + B*w;
    P_p(:,:,i-1) = A*P_n(:,:,i-1)*A' + Q;
    %     P_p(:,:,i-1) = diag(diag(P_p(:,:,i-1)));  % For diagonal only
    % -------------- Update Stage : (_n) ------------- %
    u = sig*(-1+2*rand);               % Random Noise
    
    if t(i) < tf/3
        T_meas = T_true;
    elseif  t(i) < tf*(2/3)
        T_meas = T_true + 10;
    else
        T_meas = T_true + 20;
    end
    
    V(i) = T_meas + u;                 % Random Process
    R = 1; %covariance(u, 1);           % (flag==1) for Off Diagonal
    KG(:,:,i-1)  = P_p(:,:,i-1)*H'*( H*P_p(:,:,i-1)*H' + R )^-1;
    x_n(:,i) = x_p(:,i-1) +  KG(:,:,i-1)*( V(i) - H*x_p(:,i-1) );
    P_n(:,:,i) = (eye(M_rank) - KG(:,:,i-1))*P_p(:,:,i-1);
    % --------------- Riccati Equation --------------- %
    %     F = phi;    G = B;     P = P_p;
    %     dP(:,i) = F*P + P*F' + G*Q*G' - P*H'*(R^-1)*H*P;
end

%%
close all; hold on; grid on;
plot(1:N-1, x_p(M_rank,1:N-1), 'b-', 1:N,  x_n(M_rank,1:N), 'r--', 'LineWidth', 2);
plot( 1:N, T_true*ones(1,N), 'k--', 'LineWidth', 1.5);       % Measurement

scatter(1:N-1, V(M_rank,2:N), 'gx', 'LineWidth', 3)

ind_1(1) = title('Kalman Filter Implementation');
ind_1(2) = xlabel('Iteration [$\#$]');
ind_1(3) = ylabel('Tempratue [$^\circ$]'); % [$\frac{m}{sec}$]
ind_1(4) = legend('Predicted', 'KF', 'Measured');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 16 );
