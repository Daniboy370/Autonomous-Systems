function dX = X_nav( X )
% ------------------------ Description ---------------------- %
%                                                             %
%            Calculate navigation state of the model          %
%       Return : Position, velocity, orientation (X,Y,Z)      %
%                                                             %
%  State vector of the Extended Kalman Filter representation: %
%                                                             %
%       State                         Units        Index      %
%       Position      (NED)           m            S(1:3)     %
%       Velocity      (NED)           m/s          S(4:6)     %
%       missalignment (NED)           rad          S(7:9)     % 
%       acc.  Bias    (XYZ)           rad/s        S(10:12)   % 
%       gyro. Bias    (XYZ)           m/s          S(13:15)   %
% ------------------------ Content -------------------------- %

global f_ib_b g_n gyro h lat om_n_ie om_n_en Rm Rn T_n_b

% ------------------ Assign Position States ----------------- %
D = [1/(Rm+h) 0                   0;         % LLN to ECEF conversion
    0         1/(cos(lat)*(Rn+h)) 0;
    0         0                  -1];
V_n = [X(4) X(5) X(6)]'; 
dX(1:3) = D*V_n;                             % Velocity states

% ------------------ Assign Velocity States ----------------- %
dX(4:6) = T_n_b*f_ib_b' + g_n -( om_n_en + 2*om_n_ie )*V_n;

% ------------------ Assign Orientation States -------------- %
dT_n_b = T_n_b*skew(gyro) - ( om_n_ie + om_n_en )*T_n_b;
% [phi_ang, theta_ang, psi_ang] = R_b_DCM(dT_n_b);  % DCM to Euler angles
[phi_ang, theta_ang, psi_ang] = dcm2angle( dT_n_b, 'xyz');  % DCM to Euler angles
[dX(7), dX(8), dX(9)] = deal(phi_ang, theta_ang, psi_ang);

end