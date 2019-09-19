function [sigma, tau, E] = avar(y, tau0)
% 计算Allan方差
% 输入：y -- 数据(列向量), tau0 -- 采样时间
% 输出：sigma -- Allan方差(量纲单位与输入y保持一致), tau -- 取样时间, E -- 百分比估计误差
% 作者: Yan Gong-min, 2010-12-4
    N = length(y); n = N;
    m = fix(log2(N));   % 最大分组长度2^(m-1)
    sigma = zeros(m,1);  tau = zeros(m,1);  E = zeros(m,1);  % 初始化sigma,tau,E
    for k = 1:m
        sigma(k,:) = sqrt(1/2*sum([y(2:end,:)-y(1:end-1,:)].^2,1)/(n-1));
        tau(k,1) = 2^(k-1)*tau0;
        E(k,1) = 1/sqrt(2*(n-1));
        n = fix(n/2);
        y = (y(1:2:2*n,:) + y(2:2:2*n,:))/2;  % 分组长度加倍(数据长度减半)
    end
    loglog(tau, sigma, '-+', tau, [sigma.*(1+E),sigma.*(1-E)], 'r--'); grid on;
    xlabel('t / s'); ylabel('\sigma_A( \tau )');