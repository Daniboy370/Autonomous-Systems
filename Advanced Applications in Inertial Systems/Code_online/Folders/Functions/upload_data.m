% -------------------------- Description ------------------------- %
%                                                                  %
%   This scripts generates the necessary raw data and              %
%   produce the relevant parameter at each cycle                   %
%                                                                  %
% --------------------------- Content ---------------------------- %

global dim_err dim_est H Re GPS_std t_span
global Data_acc Data_gyro Data_GPS

% ------------------ Extract Data from files --------------------- %
dataload = {'Acc_omri.mat', 'Gyro_omri.mat', 'GPS_omri_clean.mat'};
for k = 1:3
    load(dataload{k});
end
[Data_acc, Data_gyro, Data_GPS] = deal(Acc_omri, Gyro_omri, GPS_omri_clean);
clear('Acc_omri', 'Gyro_omri', 'dataload');     % get rid of unused cells

% ----------------- Add noise to GPS measurements ---------------- %
GPS_std  = [1/Re 1/Re 1/Re]*1e-2;                   % STD of ~ 1 [m] 
Data_GPS = Data_GPS + GPS_std.*randn(length(Data_GPS), 3); % Add noise

% ----------------------------- Misc. ---------------------------- %
dim_err = 15;                                   % Total states of error
dim_est = 3;                                    % Total states of navigation
t_span  = length(Data_acc);                     % Duration of scenario [s]
H = [eye(dim_est) zeros(dim_est, dim_err-dim_est)]; % Observation matrix

% Data_GPS(:, 1:2) = rad2deg( Data_GPS(:, 1:2) ); % Convert to radians

% -------------------- Clean GPS vs. Noisy GPS ------------------- %
% figure;
% plot3(GPS_omri_clean(:,1), GPS_omri_clean(:,2), GPS_omri_clean(:,3), 'linewidth', 3);
% hold on; grid on;
% plot3(Data_GPS(:,1), Data_GPS(:,2), Data_GPS(:,3));

% -------------------------- Dataset #1 -------------------------- % 
% len = length(Acc_raw);
% ind_vec = 2:len;
% [Data_acc, Data_gyro, Data_GPS] = deal(Acc_raw(ind_vec,:), Gyro_raw(ind_vec,:), ...
%     GPS_raw(ind_vec,:));
% [phi, lam, h, time] = deal(Data_GPS(:,1), Data_GPS(:, 2), Data_GPS(:, 3), Data_GPS(:, 4) );
% clear('Acc_raw', 'Gyro_raw', 'GPS_raw', 'dataload', 'magnetic_raw.mat'); % get rid of cells

% ----------------------- Dataset (MATLAB) ----------------------- % 
    % ------------- Matlab scenario ------------- %
% dataload = {'Acc_raw.mat', 'Gyro_raw.mat', 'GPS_raw.mat', 'Euler_raw.mat'};
% for k = 1:4
%     load(dataload{k});
% end
% 
% [Data_acc, Data_gyro, Data_GPS] = deal(Acc_raw, Gyro_raw, GPS_raw);
% [Data_acc, Data_gyro, Data_GPS] = deal(Acc_omri, Gyro_omri, GPS_omri);
% clear('Acc_raw', 'Gyro_raw', 'GPS_raw', 'dataload', 'magnetic_raw.mat'); % get rid of cells

