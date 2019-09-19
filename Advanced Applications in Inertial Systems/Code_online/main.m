clear all; close all; clc; 
set(0, 'defaultfigurecolor', [1 1 1]);
set(groot, 'defaultLegendAutoUpdate', 'off');

global dim_err Duration dt_IMU fusion_ratio Qk Rk

% --------------- Initialization section --------------- %
addpath(genpath('Folders'));            % Add path library
global_Variables;                       % get global variables
upload_data;                            % get raw data

% -------- Time values and duration of scenario -------- %
% IMU_ratio = floor(Hz_IMU_true/Hz_IMU); Hz_IMU_true = 100;
[Hz_IMU, Hz_GPS] = deal(100, 1);      % Measurements rate [1/s]
fusion_ratio = Hz_IMU/Hz_GPS;           % Measurement ratio [-]
plot_rate = 70;            % Online plot rate  [1/s]
run_length = length(Data_acc);          % length of IMU data
dt_IMU = 1/Hz_IMU;                      % time step size
Duration = run_length*dt_IMU;           % runtime duration [sec]
numSamples = floor(Duration*Hz_IMU);    % Total number of loop steps
time_f = dt_IMU:dt_IMU:Duration;        % t_len = length(t_lin);
add_gravity = 0;                        % Add a_z gravity (linear acc. scenario)

% ---------- make an introductory script-call ---------- %
% -------- State vectors initializarion Memory --------- %
X   = zeros(numSamples, dim_err);       % Initialize navigation state vector
del_x = X; P_xyz = zeros(numSamples, 3);% Initialize error      state vector
est_err = P_xyz(:, 1) + 1e-10;          % Initialize esimation  error vector

% ------------ Extract initial ground trurth ----------- %
% Initialization :: Matlab scenario
% X(1, 1:3) = [0.7379695947942, -1.262622852613, 52.7489]; % Initialize Position
% [phi_0, theta_0, psi_0] = deal(0.0291, 0.1027, 2.0322 ); % Initial Orientation

% ------------ Extract initial orientation ------------- %
% ----- Position ------ %
X(1, 1:3) = Data_GPS(1, 1:3);           % Initialize Navigation vector
X_est = ones(numSamples, dim_err).*X(1, :);% Initialize Estimation vector

% ---- Orientation ---- %
[phi_0, theta_0, psi_0] = deal(0, 0, 0);% Initial Orientation
T_n_b = R_DCM_b(phi_0, theta_0, psi_0); % Initialize orientation matrix
X(1, 7:9) = [phi_0, theta_0, psi_0];	% Initialize orientation states

[Qk, Rk, Pk_m] = cov_matrix;            % Covariance matrix (constant)
update_properties( X(1, :), 1, T_n_b, 0 ); % Initialize geographical terms (Globaly)

for i = 1 : numSamples - 1
    update_properties( X(i, :), i, T_n_b, add_gravity ); % update Geography
    
    % ----------- Integrate Navigation States ---------- %
    T_n_b       = T_n_b     + dT_b_n(  T_n_b  )*dt_IMU;
    [X(i+1, 7), X(i+1, 8), X(i+1, 9)] = R_b_DCM( T_n_b );
    X(i+1, 1:6) = X(i, 1:6) + d_pv( X(i, 4:6)', T_n_b )*dt_IMU;
    
    % ----------- Error state :: Prediction ------------ %
    del_x_m = X_est(i+1, :) - X(i+1, :);
    [del_x_p, Pk_m] = KF_Predicition( del_x_m, Pk_m );
    del_x(i+1, :) = del_x(i, :)' + del_x_p*dt_IMU;
        
    % ----------- Error state :: Correction ------------ %
    if mod(i, fusion_ratio) == 0
        del_z = H*X(i+1, :)' - Data_GPS(i+1, :)';        % Measurement residual
        [del_x(i+1, :), Pk_m] = KF_Correction( del_x(i+1,  :)', ...
            del_z, Pk_m*dt_IMU); % <-- check (*)dt_IMU
        
        % ------ Update navigation & error states ------ %
        X_est((i+1):end, :) = ( X(i, :) - del_x(i+1, :) ).* ones (numSamples-(i), dim_err);  % Correct the navigation state
        del_x_p = 0; % Error initialization
    end
    
    % ----------- Error plot - Real time --------------- %
    est_err(i+1) = norm( Data_GPS(i, 1:2) - X_est(i, 1:2) );
    
    % ------------- 3D plot - Real time ---------------- %
    if mod(i, plot_rate) == 0 || i == 1
        online_Trajectory( X, X_est, Data_GPS, i, plot_rate );
        online_Error( est_err, time_f, i, plot_rate );
        % pause(0.05);
    end
    
    % --- Obtain trajectory in inertial NED frame ------ %
    if i > 1
        P_xyz(i, :) = LLLN_2_NED(X, i);
    end
end

sum_process( X, i, time_f ); line_width = 3;
GT_xyz = zeros(i, 3);

% plot_graphs;
