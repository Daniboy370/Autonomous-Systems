function [Q, R, P_0] = cov_matrix
% -------------------------- Description ------------------------- %
%                                                                  %
%           This function computes R, Q, P_0 covariances           %
%                                                                  %
% --------------------------- Content ---------------------------- %
global GPS_std
% ----------- Process Noise Covariance ( acc + gyro ) -----------  %
Acc_Noise  = [1 1 1]*1e-4;
Gyro_Noise = [1 1 1]*1e-8;
GPS_Noise  = [1 1 1]*1e-9;
% Acc_BiasNoise = [1e-4 1e-4 1e-4];
% Gyro_BiasNoise = [1e-10 1e-10 1e-10];

% Q = diag([Acc_Noise, Gyro_Noise, Acc_BiasNoise, Gyro_BiasNoise]);
% Q = diag([0.01, 0.01, 0.01, 0.5, 0.5, 0.1, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3]);
Q = diag([Acc_Noise Gyro_Noise ones(1, 9)*0.00001]);

% -------------- Measurement (GPS) Noise Covariance -------------  %
R = diag(GPS_std);    % GPS Position measurement noise
 
% -------------------- Error State Covariance -------------------- %
P_0 = Q; % ?
% diag([ r_gps_noise*[1 1 1]'; v_gps_noise*[1 1 1]'.^2; 0.01*[1 1 1]']);
end
