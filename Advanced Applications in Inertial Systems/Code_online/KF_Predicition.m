function [del_x_p, P_p] = KF_Predicition( del_x_m, P_m)
% ------------------------ Description ----------------------- %
%                                                              %
%   --- Kalman Filter prediction stage on the Error State ---  %
%        Return : predicted state, predicted error cov.        %
% ------------------------- Content -------------------------- %

global Phi Qk

% (!) Note : Q covariance must be aligned with initial noise (!)

%  Update nominal state w.r.t motion 
del_x_p = Phi*del_x_m'; % + Gk*du*dt_IMU;          % x^(-) (!) du does not influence P(t) (!)
% Propagate uncertainty
P_p = Phi*P_m*Phi' + Qk;                        % Pk^(-)

end