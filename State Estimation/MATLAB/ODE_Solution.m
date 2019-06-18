%% --------------------------- ODE 45 ---------------------------- %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

syms x(t)

dx  = diff(x,t);
ddx = diff(x,2);
Eqn = ddx - 1 == 0;
Y_vec = odeToVectorField(Eqn);
Y_Eq  = matlabFunction(Y_vec, 'vars', {'t', 'Y'});
Y_st  = ode45(Y_Eq, [0 10], [0 0]);

figure; hold on; grid on;
plot(Y_st.x, Y_st.y(1,:), '-', 'LineWidth', 3)
plot(Y_st.x, Y_st.y(2,:), '-', 'LineWidth', 3)

figure; hold on; grid on;
Y = dsolve(Eqn, [dx(0)==0 x(0)==0]);
y = inline(Y);
ezplot(y, [0 10])

%%
A = [0 1; -g/l 0];
B = [0; tau/(m*l^2)];
C = [1 0]; D = 0;

F = ss(A, B, C, D, 0.1); 
x0 = [1 1]';
initial(F, x0, 10)

