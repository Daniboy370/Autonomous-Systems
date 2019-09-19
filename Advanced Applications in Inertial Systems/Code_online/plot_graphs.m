% -------------------------- Description ------------------------- %
%                                                                  %
%                  Plot desirable graphs of program                %
%                                                                  %
% --------------------------- Content ---------------------------- %

global fig_loc

% -------------- del_x = X_est - X -------------- %
figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% scatter3( P_x, P_y, P_z, 'MarkerEdgeColor','k', 'MarkerFaceColor', [0 .5 .5]);
% plot3( del_x(:, 1), del_x(:, 2), del_x(:, 3), '-', 'linewidth', 2);


plot( time_f, del_norm, '-', 'linewidth', 2);
% plot3( GT_xyz(:, 1), GT_xyz(:, 2), GT_xyz(:, 3), '-', 'linewidth', 2);
% scatter3( 0, 0, 0, 150, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r');
% view([47 28]);
ind(1) = title('$\delta x = f(\hat{X}, X, Z_{GPS}, u_{IMU})$');
ind(2) = ylabel('$Y [m]$');
ind(3) = xlabel('$X [m]$');
% ind(4) = zlabel('$Z [m]$');
%     ind(5) = legend('GPS', 'Estimated');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;


%% --------------- NED coord. vs. time ----------- %
% for k = 2:i
%     GT_xyz(k, :) = LLLN_2_NED( Data_GPS, k );
% end
% 
% % --- Could be implemented retroactively with d_fx to get NED coord. (+ P_estimated)
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% % scatter3( P_x, P_y, P_z, 'MarkerEdgeColor','k', 'MarkerFaceColor', [0 .5 .5]);
% plot3( P_xyz(:, 1), P_xyz(:, 2), P_xyz(:, 3), '-', 'linewidth', 2);
% plot3( GT_xyz(:, 1), GT_xyz(:, 2), GT_xyz(:, 3), '-', 'linewidth', 2);
% scatter3( 0, 0, 0, 150, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r');
% view([38 45]);
% ind(1) = title('$P_{NED}(t)$');
% ind(2) = ylabel('$Y [m]$');
% ind(3) = xlabel('$X [m]$');
% ind(4) = zlabel('$Z [m]$');
% %     ind(5) = legend('GPS', 'Estimated');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;
% 
% % -------------- LLLN coord. vs. time ----------- %
% r2d = rad2deg( X(1:i, 1:2) );            % convert ECEF angles from radians
% [X(1:i, 1), X(1:i, 2)] = deal( r2d(:, 1), r2d(:, 2) ); clear r2d;
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% % yyaxis left;
% plot(t_lin(1:i), X(1:i, 1), '-', 'linewidth', line_width);
% plot(t_lin(1:i), X(1:i, 2), '-', 'linewidth', line_width);
% ind(1) = ylabel('Angle $[^\circ]$');
% yyaxis right;
% plot(t_lin(1:i), X(1:i, 3), '-', 'linewidth', 2);
% ind(2) = title('Meridians vs. time (Me - INS)');
% ind(3) = xlabel('Time [s]');
% ind(4) = ylabel('Altitude [m]');
% ind(5) = legend('$\phi$', '$\lambda$', '$h$');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;
% 
% % -------------- Velocities vs. time ------------ %
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% plot(t_lin(1:i), X(1:i, 4:6), '-', 'linewidth', line_width);
% ind(1) = title('Velocities vs. time');
% ind(2) = xlabel('Time [s]');
% ind(3) = ylabel('Velocity $[m/sec]$');
% ind(4) = legend('$V_N$', '$V_E$', '$V_D$');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;
% 
% % ------------ Euler angles vs. time ----------- %
% r2d = rad2deg( X(1:i, 7:9) );            % convert body angles from radians
% [X(1:i, 7), X(1:i, 8), X(1:i, 9)] = deal( r2d(:, 1), r2d(:, 2), r2d(:, 3));
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% plot(t_lin(1:i), X(1:i, 7:9), '-', 'linewidth', line_width);
% ind(1) = title('Euler angels vs. time');
% ind(2) = xlabel('Time [s]');
% ind(3) = ylabel('Angle $[^\circ]$');
% ind(4) = legend('$\phi$', '$\theta$', '$\psi$');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;
% 
% 
% %% --------------- Gyroscope output ------------- %
% line_width = 1.5;
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% plot(t_lin(1:i), Data_gyro(1:i, :), '-', 'linewidth', line_width);
% ind(1) = title('$\omega_{ib}^b$ \ (gyroscope)');
% ind(2) = xlabel('Time [s]');
% ind(3) = ylabel('Angular Velocity $[rad/sec]$');
% ind(4) = legend('$\omega_{x}$', '$\omega_{y}$', '$\omega_{z}$');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); clear ind;
% %
% % ------------ Accelerometer output ------------ %
% figure('rend', 'painters', 'pos', fig_loc); grid on; hold on;
% plot(t_lin(1:i), Data_acc(1:i, :), '-', 'linewidth', line_width);
% ind(1) = title('$f_{ib}^b$ \ (Accelerometer)');
% ind(2) = xlabel('Time [s]');
% ind(3) = ylabel('Acceleration $[m/sec^2]$');
% ind(4) = legend('$a_x$', '$a_y$', '$a_z$');
% set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
