function update_properties( X, i_IMU, T_n_b, add_gravity )
% -------------------------- Description ------------------------- %
%                                                                  %
%       Update geographical properties due to object motion        %
%                                                                  %
% --------------------------- Content ---------------------------- %

global dim_err Data_acc Data_gyro e f_ib_b f_n_INS g g_n gyro h lat long 
global om_ie om_n_ie om_n_en om_n_in Om_b_ib Re Rm Rn vn ve vd
global du dt_IMU Fk Gk Phi                            % Prediction Matrices

% -------------- Obtain LLN state Position --------------------- %
[lat, long, h] = deal( X(1), X(2), X(3) );

% -------------- Obtain LLN state Velocities ------------------- %
[vn, ve, vd]  = deal( X(4), X(5), X(6) );

% -------------- Obtain LLN state Euler angles ----------------- %
% T_n_b        = R_n_b( X(7), X(8), X(9) );

% --------------- Update geocentric properties ----------------- %
Rm = Re*(1-e^2)/(1-e^2*sin(lat)^2)^(3/2);   % Normal   Radius
Rn = Re/sqrt(1-e^2*sin(lat)^2);             % Meridian Radius
g = g_calc(lat, h);                         % Calculate actual g(R, h)
g_n = [0;0; g*(Re/(Re+h))^2*(1+0.0052884*sin(lat)^2-0.0000059*sin(2*lat)^2)];
    
% -------------- Compute LLN state missalignment variables ----- %
om_n_en = skew([ve/(Rn + h) -vn/(Rm+h) -ve*tan(lat)/(Rn+h)]');
om_n_ie = skew(om_ie*[cos(lat) 0 -sin(lat)]');
om_n_in = om_n_ie + om_n_en;

% -------------- Add aritificial gravity measurement ----------- %
if add_gravity                              % If flag is approved
    Data_acc(i_IMU, :) = Data_acc(i_IMU, :) - g_n';
end

% -------------- Compute IMU output in Navigation frame -------- %
[f_ib_b, gyro] = deal( Data_acc(i_IMU, :), Data_gyro(i_IMU, :) );
f_n_INS = T_n_b * f_ib_b' ;                 % acc. in navigation frame
Om_b_ib = skew( gyro' );                    % gyro in navigation frame

% -------------- Compute current Matrices ------------- %
du  = vertcat(gyro', f_ib_b', zeros(6, 1) ); % Control    vector
Fk  = F_matrix( X, T_n_b );                  % State      matrix
Gk  = G_matrix(    T_n_b );                  % Control    matrix
Phi = expm(Fk*dt_IMU);                      % Transition matrix

end