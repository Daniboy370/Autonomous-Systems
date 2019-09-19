function T_nb_1 = dT_b_n( T_n_b )
% ------------------------ Description ---------------------- %
%                                                             %
%            Calculate navigation state of the model          %
%       Return : Position, velocity, orientation (X,Y,Z)      %
%                                                             %
%  State vector of the Extended Kalman Filter representation: %
%                                                             %
%       State                         Units        Index      %
%       missalignment (NED)           rad          S(7:9)     % 
%                                                             %
% ------------------------ Content -------------------------- %

global gyro om_n_ie om_n_en

% ------------------ Assign Orientation States -------------- %
T_nb_1 = T_n_b*skew(gyro) - ( om_n_ie + om_n_en )*T_n_b;
