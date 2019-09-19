function [Xk, Pk] = ukf(Xk_1, Pk_1, Pw, Pv, Zk, hFun, tVar, H)
%   测量线性、噪声加性时的 UKF 滤波
    % 计算参数
    alpha = 1e-3; beta = 2; kappa = 0;
    L = length(Xk_1);
    lambda = alpha^2*(L+kappa) - L;
    Wm = repmat(1/(2*(L+lambda)), 2*L+1, 1);
    Wm(1,1) = lambda/(L+lambda);
    Wc = Wm; 
    Wc(1,1) = Wm(1,1) + (1-alpha^2+beta);
    % 构造sigma点
    gamma = sqrt(L+lambda);
    c = gamma*chol(Pk_1)';
    rXk_1 = repmat(Xk_1,1,L);
    chi = [Xk_1, rXk_1+c, rXk_1-c];
    % 状态预测及方差预测
    Xkk_1 = zeros(L,1); chikk_1 = chi;
    for k=1:1:2*L+1
        chikk_1(:,k) = feval(hFun, chi(:,k), tVar);
        Xkk_1 = Xkk_1 + Wm(k)*chikk_1(:,k);
    end
    Pxx = Pw;
    for k=1:1:2*L+1
        xerr = (chikk_1(:,k)-Xkk_1);
        Pxx = Pxx + Wc(k)*xerr*xerr';
    end
    % 滤波
    Pxz = Pxx*H';
    Pzz = H*Pxz+Pv;
    Kk = Pxz*Pzz^-1;
    Xk = Xkk_1+Kk*(Zk-H*Xkk_1);
    Pk = Pxx-Kk*Pzz*Kk';
