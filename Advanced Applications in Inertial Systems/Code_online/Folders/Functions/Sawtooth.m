clc; clear all; close all;
set(0, 'defaultfigurecolor', [1 1 1]);
fig_loc = [2300 300 1000 550];

[dt, t_f] = deal(0.025, 50);
std_noise = 0.033;

fusion_ratio = linspace(1, 100, 15); 
% fusion_ratio = linspace(1, 100, 15); 
% fusion_ratio(1) = 1;
fuse_len = length( fusion_ratio );
f = @(x) x + std_noise*randn(1, length(x)); % consider std size (!)
y = zeros(fuse_len, floor(t_f/dt));

for k = 1:fuse_len
    num_segments = floor( t_f/(fusion_ratio(k)*dt) );
    t   = dt:dt:(fusion_ratio(k)*0.01);
    for i = 1:num_segments
%         j = 1 + (i-1)*fusion_ratio(k);
        j = length(t);
        y(k, 1+j*(i-1):j*i ) = f(t) + (fusion_ratio(k)*1e-4)*i;
    end
end

% ---- Ensure positive (!) ---- %
shorten = 10; y(y<0) = 0;
y = y(:, 1:length(y)/shorten)*1.2e-7;
t_lin = dt:dt:t_f/shorten;
% t_lin = t_lin(1:fusion_ratio(k)*num_segments);
% ---- Ensure positive (!) ---- %

figure('rend', 'painters', 'pos', fig_loc); hold on; grid on; 
% zlim([0 1])
% for i = 1:fuse_len
%     plot( t_lin, y(i, :), 'k-', 'linewidth', 1.2);
% end
surface( t_lin, fusion_ratio, y ); 
view([-25 18]); alpha(0.55); 
% ylim([fusion_ratio(1) fusion_ratio(end)]);
% set(gca, 'YScale', 'log');
ind(1) = title('Accuracy error vs. fusion ratio');
ind(2) = xlabel('Time [sec]');
ind(3) = ylabel('$\frac{Hz_{IMU}}{Hz_{GPS}}$');
ind(4) = zlabel('$\| \  \tilde{z}_{GPS} - \hat{p}_{est} \ \|$');
% b = get(gca,'zTickLabel'); set(gca,'zTickLabel', b, 'FontName','Times','fontsize', 14);
set(ind, 'Interpreter', 'latex', 'fontsize', 22 );


