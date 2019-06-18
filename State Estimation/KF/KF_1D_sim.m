clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

dt = 0.01;                          % Time step size
A = [1 dt; 0 1];                    % State space Matrix
% A = expm(A);                        % State Transition Matrix
B = [0.5*dt^2 dt]';                 % Control Matrix
C = eye(2);
D = [0 0]';

sim('KF_sim');
