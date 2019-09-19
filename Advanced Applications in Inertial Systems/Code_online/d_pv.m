function X_k_1 = d_pv( V_n, T_n_b )
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
%                                                             %
% ------------------------ Content -------------------------- %

global f_ib_b g_n h om_n_ie om_n_en lat Rm Rn

% ------------------ Assign Position States ----------------- %
D = [1/(Rm+h) 0                   0;   % LLN to ECEF conversion
    0         1/(cos(lat)*(Rn+h)) 0;
    0         0                  -1];
X_k_1(1:3) = D*V_n;           

% ------------------ Assign Velocity States ----------------- %
X_k_1(4:6) = T_n_b*f_ib_b' + g_n -( om_n_en + 2*om_n_ie )*V_n;

end