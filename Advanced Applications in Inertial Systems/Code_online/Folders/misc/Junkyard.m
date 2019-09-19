% -------------------------- Description ------------------------- %
%                                                                  %
%             Junkyard for commented line inside script            %
%                                                                  %
% --------------------------- Content ---------------------------- %

%% --------------------- Synthetic Scenario ---------------------- %
[f_IMU, f_GPS] = deal(1/50, 1);         % Sampling   frequency [Hz]
fusion_ratio = f_GPS/f_IMU;             % Sampling   ratio

% -------------- Synthetic scenario -------------- %
Duration = 10;       % [sec]
ms = 1/1000; dt_IMU = 10*ms; t_max = Duration/dt_IMU + 1;
t_lin = 0:dt_IMU:Duration;              % t_len = length(t_lin);

% --------- Acceleration Values --------- %
Data_acc  = zeros(1e4, 3);
Data_acc(1:5/dt_IMU, 1) = 10; % a_x 1 [m/sec2]
Data_acc(500:700, 2) = -5;    % a_x 1 [m/sec2]
Data_acc(1:t_max, 3) = 9.78;  % a_x 1 [m/sec2]

% ------------- Gyro Values ------------- %
Data_gyro = zeros(1e4, 3); 
Data_gyro(1:3/dt_IMU, 1) = pi/3;  % g_x 1 [m/sec2]
Data_gyro(500:700, 2) = -5;     % g_x 1 [m/sec2]
Data_gyro(1:t_max, 3) = 9.78;   % g_x 1 [m/sec2]


%% -------------------- Clean IMU measurements ------------------- %
t_acc =  (t_span/dt_IMU)/5; % Data_acc (1:t_acc,  1) = ones(t_acc,  1)*10;
t_gyro = (t_span/dt_IMU)/3; Data_gyro(1:t_gyro, 2) = ones(t_gyro, 1)*(pi/10);

% ---------- Noisy IMU measurements ---------- %
[Data_acc, Data_gyro] = deal(zeros(3485, 3), zeros(3485, 3) );
t_IMU =  (t_span/dt_IMU)/3;
acc_mean  = 10; acc_std  = 1;
gyro_mean =  pi/5; gyro_std = 0.1;
Data_acc (1:t_acc,  1) = acc_mean + acc_std*randn(t_acc,  1);
Data_gyro(1:t_IMU,  1) = gyro_mean + gyro_std*randn(t_IMU,  1); % understand the problem (!)
t_gyro = (t_span/dt_IMU)/3; Data_gyro(1:t_gyro, 3) = ones(t_gyro, 1)*(pi/5);


