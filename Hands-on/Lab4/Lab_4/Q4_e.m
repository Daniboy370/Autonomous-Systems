%% ---------- 3D Presentation of Triangulation points ---------- %
hold on; grid on; view([-39 34]);
plot3([3.794 3.794], [1.495 1.495], [0 0.5], 'k--', 'LineWidth', 1.5);
scatter3(X_Mo_cap(1), X_Mo_cap(2), X_Mo_cap(3), 'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75] );
scatter3(X_Odom(1), X_Odom(2), X_Odom(3), 'MarkerEdgeColor','k','MarkerFaceColor', 'r' );
scatter3(Lnd_2(1), Lnd_2(2), Lnd_2(3), 'MarkerEdgeColor','k','MarkerFaceColor', 'b' );

ind(1) = xlabel('X axis'); ind(2) = ylabel('Y axis');
xlim([0 5]); ylim([0 3]); zlim([0 0.5]);
ind(4) = title('Triangulation of 3D points in ANPL');
ind(5) = legend('Mo-cap', 'Odometry', 'True');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 ); 