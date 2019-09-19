function X_p1 = dr_n( X )
% ------------------------ Description ---------------------- %
%                                                             %
%            Calculate navigation state of the model          %
%       Return : Position, velocity, orientation (X,Y,Z)      %
%                                                             %
%  State vector of the Extended Kalman Filter representation: %
%                                                             %
%       State                         Units        Index      %
%       Position      (NED)           m            S(1:3)     %
%                                                             %
% ------------------------ Content -------------------------- %

global h phi Rm Rn

% ------------------ Assign Position States ----------------- %
D = [1/(Rm+h) 0                   0;      % LLN to ECEF conversion
    0         1/(cos(phi)*(Rn+h)) 0;
    0         0                  -1];
V_n = [X(1) X(2) X(3)]'; 
X_p1 = D*V_n;                             % Velocity states

end