function [Xk, Pk_p, KG] = KF(Phi, Qk, Xk_1, Pk_m1, Hk, Rk, Zk)
if nargin<7 
    Xk = Phi*Xk_1;
    Pk_p = Phi*Pk_m1*Phi'+Qk;
else
    % ------------- Prediction ------------ %
    Xk_m = Phi*Xk_1;                        % State Prediction
    Pk_m = Phi*Pk_m1*Phi' + Qk;             % 
    % ------------- Correction ------------ %
    KG = Pk_m * Hk'*(Hk*Pk_m*Hk' + Rk)^-1;  % Kalman Gain
    e_k = (Zk - Hk*Xk_m);                   % Innovation / measurement residual
    Xk = Xk_m + KG*e_k;                     % State Update
    Pk_p = ( eye(length(Phi)) - KG*Hk)*Pk_m;
end
