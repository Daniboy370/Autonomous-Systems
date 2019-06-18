clc; close all; clear all; set(0,'defaultfigurecolor',[1 1 1]);
% ************************ Trial - Integration ************************ %

t_0 = 0; t_F = 10; dt = .01;
N = ( t_F - t_0 )/dt;
t = linspace( t_0, t_F, N);

IC = -133;

tic;
F = @(t,x) 3*t.^2;
Y = RK_4( t, F, dt, IC );
toc;

tic;
opts = odeset('RelTol',1e-12,'AbsTol',1e-12);
[T0,X] = ode45( F, [t_0 t_F], IC, opts);
toc;

hold on;
plot(t, Y, 'b', 'linewidth', 1.5);
plot(T0, X, 'r', 'linewidth', 1.5);
