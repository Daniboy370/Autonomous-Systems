function [del_x_p, Pk_p] = KF_Correction( del_x_m, del_z, P_m )
% ------------------------ Description ----------------------- %
%                                                              %
%       Kalman Filter correction stage on the Error State      %
%       Input  : Navigation states vs. GPS corrected states    %
%       Output : corrected state, corrected error cov.         %
%                                                              %
% ------------------------- Content -------------------------- %

global dim_err H Rk

% ----- Assign entries w.r.t the projected measurements ------ %
% [O_3x3, I_3x3] = deal(zeros(3), eye(3) );  % Fill in entries
% H = [I_3x3, O_3x3, O_3x3, O_3x3, O_3x3];  % Loosely coupled == GPS_position

% -------- Compute Kalman Gain -------- %
K_g = P_m*H'*(H*P_m*H' + Rk)^-1;
% -------- Innovation ----------------- %
Inn = ( del_z - H*del_x_m );
% -------- Compute error cov. --------- %
Pk_p = (eye(dim_err) - K_g*H)*P_m;
% -------- Compute corrected state ---- %
del_x_p = del_x_m + K_g*Inn;

end