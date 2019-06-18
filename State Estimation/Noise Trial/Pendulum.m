clc; clear all;

g = 9.81;
m=1; l=1; tau=1;

A = [0 1; -g/l 0];
B = [0; tau/m/l^2];
C = [1 0]; D = 0;

Tf = ss2tf(A, B, C, D);
sim('Pendulum_Noise');
plot(Theta)


