function online_Trajectory( X, X_est, Data_GPS, i, i_last )
% -------------------------- Description ------------------------- %
%                                                                  %
%        Real time presentation of position in Earth coord.        %
%                                                                  %
% --------------------------- Content ---------------------------- %
global dt_IMU Duration fig_nav fusion_ratio

fig_loc = [2300 400 800 600];           % NOTE : locate window opening (!)

if i == 1
    fig_nav = figure('name', 'Total State', 'rend', 'painters', 'pos', fig_loc);
    [lat, long, h] = deal( rad2deg(X(i, 1)), rad2deg(X(i, 2)), X(i, 3) );
    scatter3( long, lat, h, 'MarkerEdgeColor','k', 'MarkerFaceColor', [0 .75 .75]); hold on;
    plot3( long, lat, h, 'bo-', 'linewidth', 1.25);
    plot3( long, lat, h, 'ro-', 'linewidth', 1.25);
    ind(1) = title(['$P_{e}(t)$ @ t = 0 [sec]; \ $\frac{Hz_{IMU}}{Hz_{GPS}}$ = ', num2str(fusion_ratio), ';']);
    ind(2) = ylabel('$\phi [^\circ]$');
    ind(3) = xlabel('$\lambda [^\circ]$');
    ind(4) = zlabel('Altitude $[m]$');
    ind(5) = legend('$P_{INS}$', '$\hat{P}_{EST}$', '$P_{GPS}$', 'location', 'northeast');
    set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
    clear ind;
else
    figure(1); hold on;
    [lat_1, long_1, h_1] = deal( rad2deg(X(i, 1)), rad2deg(X(i, 2)), X(i, 3) );
    scatter3( long_1, lat_1, h_1, 'MarkerEdgeColor','k', 'MarkerFaceColor',[0 .75 .75]);
    %     plot3( lam_1, phi_1, h_1, 'bo-');
end

% ------------ Make consecutive line between points ----------- %
if i > 1
    figure(1); hold on;
%     set(fig,'defaultLegendAutoUpdate','off');

    if i == i_last
        i_last = i_last - 1;
    end
    
    % ------------------ Plot INS trajectory ------------------ %
    t_step = i*dt_IMU;
    str = sprintf('$P_{e}(t)$ @ t = %.2f / %.2f  [sec]', t_step, Duration);
    title([str '; \ $\frac{Hz_{IMU}}{Hz_{GPS}}$ = ', num2str(fusion_ratio), ';'], 'fontsize', 16);
    [lat, long, h] = deal( rad2deg(X(i-i_last, 1)), rad2deg(X(i-i_last, 2)), X(i-i_last, 3) );
    plot3( [long long_1], [lat lat_1], [h h_1], 'k--', 'linewidth', 1.5);
    
    % ------------------ Plot Estimated trajectory ------------ %
    [EST_x_0, EST_y_0, EST_z_0] = deal( X_est(i-i_last, 1), X_est(i-i_last, 2), X_est(i-i_last, 3) );
    [EST_x_1, EST_y_1, EST_z_1] = deal( X_est(i,   1), X_est(i,   2), X_est(i,   3) );
    EST_dy = rad2deg( [EST_y_0 EST_y_1] );
    EST_dx = rad2deg( [EST_x_0 EST_x_1] );
    EST_dz = [EST_z_0 EST_z_1];
    plot3(EST_dy , EST_dx, EST_dz, 'bo--', 'linewidth', 1.25);
    
    % ------------------ Plot GPS trajectory ------------------ %
    [GPS_x_0, GPS_y_0, GPS_z_0] = deal( Data_GPS(i-i_last, 1), Data_GPS(i-i_last, 2), Data_GPS(i-i_last, 3) );
    [GPS_x_1, GPS_y_1, GPS_z_1] = deal( Data_GPS(i,   1), Data_GPS(i,   2), Data_GPS(i,   3) );
    GPS_dy = rad2deg( [GPS_y_0 GPS_y_1] );
    GPS_dx = rad2deg( [GPS_x_0 GPS_x_1] );
    GPS_dz = [GPS_z_0 GPS_z_1];
    plot3(GPS_dy , GPS_dx, GPS_dz, 'ro-', 'linewidth', 1.25);
    
    %---- Calculate distance between 2 consecutive points ---- %
    %     distance_on_earth = Lat_Lon_distance([phi lam], [phi_1 lam_1]);
    %     fprintf('   Earth distance : %.2f [m]        Duration : %.2f [sec]. \n', distance_on_earth, t_step );
end

% view([0 90])