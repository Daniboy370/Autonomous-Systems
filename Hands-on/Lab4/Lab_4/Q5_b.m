%% ------ Calculating The Weighted Normalized Difference ------- % 
hold on; WND_OD = zeros(12,1); WND_MC = WND_OD;
for j=1:2
    for i=1:length(run_i)
        if j-1 == 1
            WND_MC(i) = ( sum(run_i(1:i)) * sum(err_Mo_cap(1:i)) )/sum( run_i(1:i));
        else
            WND_OD(i) = ( sum(run_i(1:i)) * sum(err_Odom(1:i)) )/sum( run_i(1:i));
        end
    end
end

hold on;
plot(1:i, WND_OD, 'b', 'linewidth', 2);
plot(1:i, WND_MC, 'r', 'linewidth', 2);
ind(1) = xlabel('WND');
ind(2) = ylabel('3D Triangulation Error');
ind(3) = title('3D Triangulation Error Vs. WND');
ind(4) = legend('Mo-cap', 'Odometry');
set(ind, 'Interpreter', 'Latex', 'fontsize', 18 );
aa = get(gca,'XTickLabel');
set(gca,'XTickLabel', aa, 'FontName','Times','fontsize',16);