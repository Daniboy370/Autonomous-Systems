function P_xyz =  LLLN_2_NED(X, i)
% -------------------------- Description ------------------------- %
%                                                                  %
%   This function converts coordinates from Earth frame to NED     %
%                                                                  %
% --------------------------- Content ---------------------------- %

global Rm Rn

% Consider make [P_n, P_e, P_d] as an output if needed

[Lat, Alt]          = deal( X(i-1, 1), X(i-1, 3) );
[dLat, dLong, dAlt] = deal( X(i, 1)-X(1, 1), X(i, 2)-X(1, 2), X(i, 3)-X(1, 3) );

P_n = dLat*(Rm + Alt);
P_e = dLong*(Rn + Alt)*cos(Lat);
P_d = dAlt;
P_xyz = [P_e P_n P_d];

end