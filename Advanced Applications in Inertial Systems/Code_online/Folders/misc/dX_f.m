function [X_k_1, T_nb_1] = dX_f( X_k )
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

global f_ib_b g_n gyro h om_n_ie om_n_en phi Rm Rn T_n_b

% ------------------ Assign Position States ----------------- %
D = [1/(Rm+h) 0                   0;         % LLN to ECEF conversion
    0         1/(cos(phi)*(Rn+h)) 0;
    0         0                  -1];
V_n = [X_k(4) X_k(5) X_k(6)]'; 
X_k_1(1:3) = D*V_n;                             % Velocity states

% ------------------ Assign Velocity States ----------------- %
X_k_1(4:6) = T_n_b*f_ib_b' + g_n -( om_n_en + 2*om_n_ie )*V_n;

% ------------------ Assign Orientation States -------------- %
T_nb_1 = T_n_b*skew(gyro) - ( om_n_ie + om_n_en )*T_n_b;

end