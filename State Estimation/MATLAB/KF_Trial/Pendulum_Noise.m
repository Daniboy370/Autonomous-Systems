clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
% ------------- Simple Pendulum with Constant Torque applied ------------- %

g = 9.81;
m=1; l=1; tau=1;

A = [0 1; -g/l 0];
B = [0; tau/m/l^2];
C = [1 0]; D = 0;

sim('Pendulum_Noise');
plot(Theta)

%% ---------------------- Matlab Call - Not working ----------------------- %
A = [0 1;-1 0];
B = [0; 1];
C = [0 1];
D = 0;
K = [1; 1];
% Ts = 0 indicates continuous time

T_func = idss(A,B,C,D,K,'Ts',0,'NoiseVariance',7);
step(T_func, 15)

