clear all; clc; close all;
% This script implements the linear Kalman filter and shows its performance
% on a 2nd order under-damped LTI system.

% In the first part, a noisy model with two state variables is simulated and
% in the second part, Kalman filtering is applied to estimate the real observations.

% Model characteristics
% X(t) = A * X(t-1) + V(t) ---> A: State transition matrix, V=N(Mv,Q) : Process noise
% y(t) = C * X(t)   + N(t) ---> C: Output matrix          , N=N(Mr,R) : Observation noise

StateDim = 2;                      % Number of states ( size(A,1) )
ObsDim = 1;                        % Number of observations ( size(C,1) )

A = [1.9223   -0.9604              % 2nd order under-damped LTI system
    1.0000         0];

C = zeros(ObsDim,StateDim);        % Matrix C (Between outputs ans states), C = [I 0 0 ...]
C(:,1) = 1;

N  = 100;                         % Number of datapoints
X  = zeros(StateDim,N);            % State data buffer
y  = zeros(ObsDim,N);              % Observation data buffer

% Generate Process Noise (Noise of the state equations)
Var_PNoise = .1;                   % Process Noise variance
Mu_PNoise = 0;                     % Process Noise mean
Std_PNoise = sqrt(Var_PNoise)';    % Standard deviation of the process noise
PNoise = Std_PNoise * randn(StateDim,N) + Mu_PNoise*ones(StateDim,N);    % Gaussian Process Noise
Q = cov(PNoise');                  % Process Noise Covariance Matrix

% Generate Observation Noise (Noise of the output equation0
Var_ONoise = 2;                    % Observation Noise variance
Mu_ONoise = 0;                     % Observation Noise mean
Std_ONoise = sqrt(Var_ONoise)';    % Standard deviation of the observation noise
ONoise = Std_ONoise * randn(ObsDim,N) + Mu_ONoise*ones(ObsDim,N);    % Gaussian Observation Noise
R = cov(ONoise');                  % Observation Noise Covariance Matrix

% Initial values for the model
X(:,1) = [1 0]';                   % Initial state
y(1) = C * X(:,1) + ONoise(:,1);   % Initial observation

% Simulate states and observations
% B and D matrices have been ignored in the model.
for i = 2 : N
    X(:,i) = A * X(:,i-1) + PNoise(:,i); % States
    y(:,i) = C * X(:,i)   + ONoise(:,i); % Real Observations
end

% Kalman filtering...
xh(:,1) = 0.01*randn(StateDim,1);    % Initial state
Px = eye(StateDim);                  % Initial state covariance matrix

for i = 1 : size(y,2)
    %---------- Time Update ----------
    % A priori estimate of the current state ( x(t|t-1) = A*x(t-1|t-1) )
    xh_(:,i) = A * xh(:,i);
   
    % A priori estimate of the state covariance matrix ( P(t|t-1) = A*P(t-1|t-1)*A' + Q )
    Px_ = A*Px*A' + Q;
   
    %---------- Measurement Update ----------
    % Kalman filter coefficient ( K(t) = P(t|t-1) * C' * inv(C*P(t|t-1) * C' + R) )
    K = Px_ * C' * inv(C*Px_*C' + R);
   
    % Estimated observation ( y(t|t-1) = C*x(t|t-1) + R )
    yh_(:,i) = C * xh_(:,i) + R;
   
    % Measurement residual error or innovation error ( y(t) - y(t|t-1) )
    inov(:,i) = y(:,i) - yh_(:,i);
   
    % A posteriori (updated) estimate of the current state ( x(t|t) = x(t|t-1) + K(t)*(y(t)-y(t|t-1)) )
    xh(:,i+1) = xh_(:,i) + K * inov(:,i);
   
    % A posteriori (updated) state covariance matrix ( P(t|t) = (I - K(t)*C) * P(t|t-1) )
    Px = Px_ - K*C*Px_;
   
end
   
%% Plot the estimation results   
figure; hold on; grid on;
plot(y, '-', 'LineWidth', 2);
plot(yh_,'-', 'LineWidth', 2);
legend('Real observation', 'Estimated observation');
