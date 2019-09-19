function [data,beta,q,omegak] = markov(sigma, tau, ts, len, order)

[m,n] = size(sigma); % n==1!
data = zeros(len, m);
if nargin<5 || order==1 %һ������ɷ����
    beta = 1./tau;
    q = 2*sigma.^2.*beta; sQk = sqrt(q*ts);
    a1 = 1-beta*ts;
    sQk = sQk'; a1 = a1';
    w = randn(len,m);
    data(1,:) = sigma'.*w(1,:);
    for k=2:len
        data(k,:) = a1.*data(k-1,:)+sQk.*w(k,:);
    end
elseif order==2 %��������ɷ����(��������������)
    beta = 2.146./tau;
    q = 4*beta.^3.*sigma.^2; sQk = sqrt(q*ts^3);
    a1 = 2*(1-beta*ts); a2 = -(1-beta*ts).^2;
    sQk = sQk'; a1 = a1'; a2 = a2';
    w = randn(len,m);
    data(1,:) = sigma'.*w(1,:); data(2,:) = data(1,:);
    for k=3:len
        data(k,:) = a1.*data(k-1,:)+a2.*data(k-2,:) + sQk.*w(k,:);
    end
    omegak = [zeros(1,m); diff(data)]/ts;
end