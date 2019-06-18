clc; close all; clear all; set(0,'defaultfigurecolor',[1 1 1]);

% Implementation of Single Accelerometer exposed
% Input of acc. Bias        % Measurement of Position

% ----------------- Dynamic Model - Free Fall of an Object ---------------- %
Position = 1;   Velocity = 2;   Bias = 3;   % State Indices
x0 = 0;         v0 = 0;         dt = 0.1;         T = 300;
% -------------------- State Vector : X = [x v b]^{T} --------------------- %
Phi = [0 dt 0; 0 0 dt; 0 0 0];
Phi = expm(Phi);    Phi(3,3) = 0;
G = [0 0 1]';

Hk = [1 0 0]; % eye(3);                     % Observation Matrix - Position
Dim_St = size(Phi,1);                         % Size of A Matrix
Dim_Ms = size(Hk,1);                        % Size of H Matrix
% ----------------------- Kalman Filter Properties ------------------------ %
mu = 0;                                     % Zero Expectancy
std_w = 0.05;                               % Acc. Bias / STD (b)
std_v = 5;                                  % Measuremnt  STD (P,V,b)
N     = T/dt;                               % Max Index

% Process Noise     - Gaussian Vector
W = zeros(3, N);
W(3,:)   = normrnd(std_w, std_w, [1 N]);
Q = cov(W');                                % Process     Noise Cov. (n x n)

% Measurement Noise - Gaussian Vector
V = normrnd(mu, std_v, [1 N]);
R = cov(V');                                % Measurement Noise Cov. (m x m)

% ---------------------- Initialize Model Properties ---------------------- %
i = 1;                                      % Initialize Dimensions
[Xe, Xe_] = deal([0 0 0]');                 % Initialize Estimators
Xk = [x0 v0 0]';       Yk = Hk*Xk + V(:,1); % Initialize State Vectors
[P(1).p, P(1).u] = deal(Q);                 % Initialize Process Error Covariance
dP = sqrt(diag(P(i).u));                    % Initialize Error   State Covariance

% ---------------------- Discrete Time System Model ---------------------- %
while i < N
    i = i+1;                                % Increment (i)
    % -------------------- State Space -------------------- %
    Xk(:,i) = Phi *Xk(:,i-1) + G*W(3,i); 
    Yk(:,i) = Hk*Xk(:,i-1) + V(:,i-1);
    % ------------------- Kalman Filter ------------------- %
    % -------------- Prediction Stage : (_p) -------------- %
    Xe_(:,i)= Phi*Xe(:,i-1) + G*W(3,i); % < - add noise here ?
    P(i).p  = Phi*P(i-1).u*Phi' + Q;
    % ---------------- Update Stage : (_n) ---------------- %
    Ik      = Yk(:,i) - Hk*Xe_(:,i);        % Innovation
    S       = Hk*P(i).p*Hk' + R;            % Innovation Covariance
    K  = P(i).p*Hk'*(S^-1);                 % Kalman Gain
    P(i).u  = (eye(Dim_St) - K*Hk)*P(i).p;
    Xe(:,i) = Xe_(:,i) + K*Ik;
    dP(:,i) = sqrt(diag(P(i).u));
end
t = dt*(1:i);                               % Span (i) Over timespan (t)

%% -------------------- Plot - Kinematics ------------------- %
figure; % figure('rend','painters','pos',[1800 60 800 700]);
% --------------------- Sub-plot Position ------------------- %
subplot(3,1,1); hold on; grid on; j = Position;
plot(t, Xk(j,:), 'r-', 'linewidth', 3.0);
ind(1) = title('Position');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('p [m]');
ind(4) = legend('Noisy', 'Normal');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

% ------------------ Position Measurement ------------------- %
subplot(3,1,2); hold on; grid on;
hold on; grid on; j = Velocity;
plot(t, Xk(j,:) , 'r-', 'linewidth', 3);
ind(1) = title('Velocity');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('v [m/s]');
ind(4) = legend('Noisy', 'Normal');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

% --------------------- Acc. Measurement -------------------- %
subplot(3,1,3); hold on; grid on; j = Bias;
plot(t, Xk(j,:), 'r-', 'linewidth', 2.0);
ind(1) = title('Acceleration');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('a [m/$s^2$]');
ind(4) = legend('Noisy', 'Normal');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

%% ------------------- Plot delta : State Errors -------------------- %
figure; % figure('rend','painters','pos',[1800 60 800 700]);
% -------------------- Position Error --------------------- %
subplot(2,1,1); hold on; grid on; j = Position;
plot(t, Xe(j,:) - Xk(j,:) , 'r-', 'linewidth', 2);
plot(t, dP(j,:), 'b--', t, -dP(j,:), 'b--', 'linewidth', 2);
ind(1) = title('Position Error');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('$\delta X$ [m]');
ind(4) = legend('$\delta X$', '$\pm \sqrt{P_X}$');
grid on; a = get(gca,'XTickLabel'); % ylim(dp*[-1 1]);
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

% -------------------- Velocity Error --------------------- %
subplot(2,1,2); hold on; grid on; j = Velocity;
plot(t, Xe(j,:) - Xk(j,:) , 'r-', 'linewidth', 2);
plot(t, dP(j,:), 'b--', t, -dP(j,:), 'b--', 'linewidth', 2);
ind(1) = title('Velocity Error');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('$\delta V$ [m/s]');
ind(4) = legend('$\delta V$', '$\pm \sqrt{P_V}$');
grid on; a = get(gca,'XTickLabel'); % ylim(dv*[-1 1]);
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

%% -------------------- Plot - Estimation ------------------- %
figure; % figure('rend','painters','pos',[1800 60 700 450]);
hold on; grid on; j = Position;
plot(t, Xk(j,:), 'm-', 'linewidth', 3.0);
plot(t, Yk(j,:), 'g-', 'linewidth', 2.5);
plot(t, Xe(j,:), 'b-', 'linewidth', 2.0);
ind(1) = title('Position Estimation');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('p [m]');
ind(4) = legend('True', 'Measured', 'Estimated');
a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
set(ind, 'Interpreter', 'latex', 'fontsize', 22);

%% --------------------- Sensor Noise --------------------- %
% figure('rend','painters','pos',[1800 60 800 500]);
% hold on; grid on;
% % ----------------- Decrement Arrays by 1 ----------------- %
% ts = t(1:i-1);  i = i-1;                   % Synchronize t with noise
% % --------------------------------------------------------- %
% scatter(ts, V(1,1:i), 'filled');
% plot(ts, zeros(i,1), 'g-', 'linewidth', 2);  % Green Line == "0" Expectancy
% sig = std(V(1,1:i),1);
% mean_u = mean(V(1,1:i));
% 
% % --------------- Plot - Standard Deviation --------------- %
% sig_Color_1 = [1.0 0.50 0.3];               % 1 Sigma
% plot(ts, ones(1,i)*(mean_u + sig), '--', 'Color', sig_Color_1, 'linewidth', 3);
% plot(ts, ones(1,i)*(mean_u - sig), '--', 'Color', sig_Color_1, 'linewidth', 3);
% sig_Color_2 = [1.0 0.80 0.4];               % 2 Sigma
% plot(ts, ones(1,i)*(mean_u + 2*sig), '--', 'Color', sig_Color_2, 'linewidth', 3);
% plot(ts, ones(1,i)*(mean_u - 2*sig), '--', 'Color', sig_Color_2, 'linewidth', 3);
% 
% % ---------------------- Plot - Style --------------------- %
% ind(1) = title('$P$ Sensor');
% ind(2) = xlabel('Time [sec]');
% ind(3) = ylabel('$P$ [m]');
% ind(4) = legend('Observed', 'True');
% plot(ts, ones(1,i)*mean_u, 'k--', 'linewidth', 3);
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel', a, 'fontsize', 14, 'XTickLabelMode', 'auto');
% set(ind, 'Interpreter', 'latex', 'fontsize', 22);
% 
% % -------------------- Text Box - Style ------------------- %
% dim =  [.65 .1 .25 .2];
% str = ['Mean = ' num2str(mean_u) newline 'STD = ' num2str(sig)];
% a = annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on');
% a.BackgroundColor = 'w';
% set(a, 'Interpreter', 'latex', 'fontsize', 18 );
% i = i+1;