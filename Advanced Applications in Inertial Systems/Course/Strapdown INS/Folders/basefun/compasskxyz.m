function [kxy, kz] = compassk(Tdxy, Tdz, xi)
global glv
    if nargin<3
        xi = sqrt(2)/2;
    end
    ws2 = glv.g0/glv.Re;    % ��������ƽ��
    sigma = 2*pi*xi/(Tdxy*sqrt(1-xi^2));    % ˮƽ��ƽ����kxy1,kxy2,kxy3
    kxy(1) = 3*sigma; 
    kxy(2) = sigma^2*(2+1/xi^2)/ws2-1; 
    kxy(3) = sigma^3/(glv.g0*xi^2);
    if nargin>=2
        sigma = 2*pi*xi/(Tdz*sqrt(1-xi^2));  % �޾���·���Ʋ���kz1,kz2,kz3
        kz(1) = 2*sigma; 
        kz(4) = kz(1); 
        kz(2) = 4*sigma^2/ws2-1; 
        kz(3) = 4*sigma^4/glv.g0;
    end
