function [b,a] = foie(tau, Ts)
% first-order inertial element filter    
% yk = -a2*yk_1 + b1*xk; <---> yk = (1-Ts/tau)*yk_1 + Ts/tau*xk
    b1 = Ts/tau;
    a2 = -(1-b1);
    b = b1;
    a = [1 a2];
