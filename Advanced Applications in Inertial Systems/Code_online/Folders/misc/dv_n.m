function X_k_1 = dv_n( V_n, T_n_b )
% ------------------------ Description ---------------------- %
%                                                             %
%            Calculate navigation state of the model          %
%       Return : Position, velocity, orientation (X,Y,Z)      %
%                                                             %
%  State vector of the Extended Kalman Filter representation: %
%                                                             %
%       State                         Units        Index      %
%       Velocity      (NED)           m/s          S(4:6)     %
%                                                             %
% ------------------------ Content -------------------------- %

global f_ib_b g_n om_n_ie om_n_en

% ------------------ Assign Velocity States ----------------- %
X_k_1 = T_n_b*f_ib_b' + g_n -( om_n_en + 2*om_n_ie )*V_n;
