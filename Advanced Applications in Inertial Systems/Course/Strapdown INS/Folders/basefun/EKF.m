function [Xk, Pk_p, KG] = EKF(Phi, Qk, fXk_1, Pk_m1, Hk, Rk, Zk)
if nargin<7
    Xk = fXk_1;
    Pk_p = Phi*Pk_m1*Phi'+Qk;
else
    % ----------- Prediction ---------- %
    Pk_m = Phi*Pk_m1*Phi' + Qk;
    S = Hk*Pk_m*Hk' + Rk;                  % Innovation matrix
    % ----------- Correction ---------- %
    KG = Pk_m*Hk'*S^-1;
    Xk = fXk_1 + KG*Zk;
%     Pk_p = Pk_m - KG*S*KG';
    Pk_p = ( eye(length(Phi)) - KG*Hk ) *  Pk_m;
end