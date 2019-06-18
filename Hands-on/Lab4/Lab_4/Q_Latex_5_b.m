%% ------- Reconstruction using Odometry / Mocap Triangulation ------- %
P_ref = P_est(22,:);
for a=22:36
    WND(a) = norm(P_ref - P_est(a));
    % -------- Obtain SPECIFIC Transformation Matrix ------- %
    T_w2c = GetTranslationMat(a, bag, 1);
    M = K*T_w2c(1:3,:);              % M : Projection Matrix
    % ------------- Form A x = b linear system ------------- % 
    b((2*a-1):(2*a),1) = [-u(a)*M(3,4) + M(1,4); -v(a)*M(3,4) + M(2,4) ];
    
    A( (2*a-1):(2*a),:) = [u(a)*M(3,1)-M(1,1),  u(a)*M(3,2)-M(1,2),  u(a)*M(3,3)-M(1,3);
        v(a)*M(3,1)-M(2,1),  v(a)*M(3,2)-M(2,2),  v(a)*M(3,3)-M(2,3)];
    if a>22 
        X_Odom(:,a) = inv(A'*A)*A'*b;
    end
end

for a=22:36
    err_Odom(a) = norm( Lnd_2 - X_Odom(:,a));
end

figure(1); hold on; grid on; box on;
plot(WND(23:36), err_Odom(23:36), 'b-', 'LineWidth', 2);
ind_1(2) = xlabel('Weighted Normalized Difference');
ind_1(3) = ylabel('3D Triangulation Error [m]');
set(gca,'FontSize', 16 );
ind_1(4) = title('3D Triangulation Error Vs. WND','FontSize',20);ind_1(1) = title('Geographic Coordinates vs. Step');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 14 );
