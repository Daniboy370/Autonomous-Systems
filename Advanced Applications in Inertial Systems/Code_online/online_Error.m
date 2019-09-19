function online_Error( est_err, time_f, i, i_last )
% -------------------------- Description ------------------------- %
%                                                                  %
%            Real time presentation of evolving error              %
%                                                                  %
% --------------------------- Content ---------------------------- %
global dt_IMU fig_err fusion_ratio
fig_loc = [2300 0 800 278];           % NOTE : locate window opening (!)

if i == 1
    fig_err = figure('name', 'Error State', 'rend', 'painters', 'pos', fig_loc);
    scatter(dt_IMU, est_err(1), 'MarkerEdgeColor','k', 'MarkerFaceColor', [.5 .8 .7]); 
    ind(1) = title(['$\| \  \tilde{z}_{GPS} - \hat{p}_{est} \ \|$ ; $\frac{Hz_{IMU}}{Hz_{GPS}}$ = ', num2str(fusion_ratio), ';']); 
    ind(2) = xlabel('$t$ $[sec]$');
    set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
    clear ind;
else
    if i == i_last
        i_last = i_last - 1;
    end
    % ------------ Make consecutive line between points ----------- %
    del_est = [est_err(i) est_err(i-i_last)];
    figure(2); hold on; grid on;
    plot([time_f(i) time_f(i-i_last)], del_est, 'k--', 'linewidth', 1);
    scatter(time_f(i), est_err(i), 'MarkerEdgeColor','k', 'MarkerFaceColor', [.5 .8 .7]);
end
