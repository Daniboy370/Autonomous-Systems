function [sigma, tau, E] = avar(y, tau0)
% ����Allan����
% ���룺y -- ����(������), tau0 -- ����ʱ��
% �����sigma -- Allan����(���ٵ�λ������y����һ��), tau -- ȡ��ʱ��, E -- �ٷֱȹ������
% ����: Yan Gong-min, 2010-12-4
    N = length(y); n = N;
    m = fix(log2(N));   % �����鳤��2^(m-1)
    sigma = zeros(m,1);  tau = zeros(m,1);  E = zeros(m,1);  % ��ʼ��sigma,tau,E
    for k = 1:m
        sigma(k,:) = sqrt(1/2*sum([y(2:end,:)-y(1:end-1,:)].^2,1)/(n-1));
        tau(k,1) = 2^(k-1)*tau0;
        E(k,1) = 1/sqrt(2*(n-1));
        n = fix(n/2);
        y = (y(1:2:2*n,:) + y(2:2:2*n,:))/2;  % ���鳤�ȼӱ�(���ݳ��ȼ���)
    end
    loglog(tau, sigma, '-+', tau, [sigma.*(1+E),sigma.*(1-E)], 'r--'); grid on;
    xlabel('t / s'); ylabel('\sigma_A( \tau )');