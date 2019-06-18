clc; clear all; close all;
h = figure(1); set(h, 'Color', [1 1 1]);

% ------------ Initialization ------------ %
a = 0; V = 0; P = 0;
N_runs = 50; N_max = 100; dt = 0.1;
tlin = linspace(dt, N_max*dt, N_max)';
% -------------- Statistics -------------- %
a = -5; b = 5;
A = zeros(N_runs, N_max); V = A; P = A;

hold on;
for j=1:N_runs
    for i=1:N_max - 1
        Exp = a + rand*(b-a);
        A(j, i+1) = A(j, i) + dt*Exp;
        V(j, i+1) = V(j, i) + A(j, i+1)*dt;
        P(j, i+1) = P(j, i) + V(j, i+1)*dt;
    end
end

plot( tlin, A, '-', 'LineWidth', 1);
ind(1) = title('Error Vs. Time');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('Amplitude');
set(ind, 'Interpreter', 'latex', 'fontsize', 16);
%%

plot( tlin, A, '-');
% plot( tlin, sqrt(V), '-');

%%     PP = mean(sqrt(P) );
%     plot( tlin, PP, '-');

% tlin = linspace(dt, N*dt, N);
% semilogy( tlin, a, '-', tlin, v, '-', tlin, p, '-');
% figure(2);
%, tlin, v, '-', tlin, p, '-');

