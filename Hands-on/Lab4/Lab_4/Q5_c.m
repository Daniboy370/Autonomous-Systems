%% ---------------------- 5.c Plot a graph ---------------------- %
hold on; grid on;
scatter(P_est(:,1), P_est(:,2), 'MarkerEdgeColor', 'k','MarkerFaceColor', 'b');
scatter(P_GT_fix(:,1), P_GT_fix(:,2), 'MarkerEdgeColor', 'k','MarkerFaceColor','r' );
% --------------- LandMarks ----------------- %
scatter(Lnd_1(1), Lnd_1(2), 300, 'k*');
scatter(Lnd_2(1), Lnd_2(2), 300, 'k*');
% ----------- 3D Triangulations ------------- %
plot(P_est(:,1), P_est(:,2), 'b--', 'linewidth', 1.5  );
plot(P_GT_fix(:,1), P_GT_fix(:,2), 'r--', 'linewidth', 1.5  );
ind(1) = xlabel('Iteration [$\#$]');
ind(2) = ylabel('3D Triangulation Error');
ind(3) = title('3D Triangulation Error Vs. WND');
