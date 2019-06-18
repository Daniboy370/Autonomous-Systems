%% ------------------------------- Lab 4 ------------------------------- %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
global K N_msgs pos_Deviat
% --------------------- Initialization ---------------------- %
Lnd_1 = [2.656 1.83  0.3]';
Lnd_2 = [3.794 1.495 0.3]';
load('cameraParams');
K = cameraParams.IntrinsicMatrix';
% ------------------- Memory Allocation --------------------- %
P_est = zeros(N_msgs, 2); P_GT = P_est;

%% -------------------- 2.a Binary Table -------------------- %
load('Img_Corr'); N_msgs = 121;
% ------------ 2.b Estimated Path of the Robot -------------- %
bag = rosbag('rosbag_ac.bag');
bag_GT  = select(bag,'Topic','/Robot_1/pose');
all_GT_Msgs = readMessages(bag_GT);
bag_est = select(bag,'Topic','/RosAria/pose');
all_est_Msgs = readMessages(bag_est);

%% --------------- Extract Paths out of Files --------------- %

for i=1:N_msgs
    c_est = all_est_Msgs{i}.Pose.Pose.Position;
    [P_est(i,1), P_est(i,2)] = deal( c_est.X, c_est.Y );
    c_GT = all_GT_Msgs{i}.Pose.Position;
    [P_GT(i,1), P_GT(i,2)] = deal( c_GT.X, c_GT.Y );
end

pos_Deviat = P_GT(1,1:2);

% % ---------------- Sorting and fitting Plots ---------------- %
% hold on; pbaspect([1 1 1]);
% plot(P_est(:,1), P_est(:,2), 'linewidth', 2.5 );
% P_GT_fix = P_GT - ones(N_msgs,1)*pos_Deviat;
% 
% Rot_mocap = angle2dcm( 0, 0, -deg2rad(90.6), 'XYZ');
% P_GT_fix = transpose(Rot_mocap*[P_GT_fix zeros(N_msgs,1)]');
% plot(P_GT_fix(:,1), P_GT_fix(:,2), 'linewidth', 2.5  )
% 
% scatter(Lnd_1(1), Lnd_1(2), 300, 'k*');
% scatter(Lnd_2(1), Lnd_2(2), 300, 'k*');
% 
% for i=1:N_msgs
%     if Img_Corr(i,1) == 1 && Img_Corr(i,2) == 1
%         plot([P_est(i,1) Lnd_1(1)], [P_est(i,2) Lnd_1(2)], 'g--', 'linewidth', 1 );
%         plot([P_est(i,1) Lnd_2(1)], [P_est(i,2) Lnd_2(2)], 'g--', 'linewidth', 1 );
%     elseif Img_Corr(i,1) == 1 && Img_Corr(i,2) == 0
%         plot([P_est(i,1) Lnd_1(1)], [P_est(i,2) Lnd_1(2)], 'g--', 'linewidth', 1 );
%     elseif Img_Corr(i,2) == 1 && Img_Corr(i,1) == 0
%         plot([P_est(i,1) Lnd_2(1)], [P_est(i,2) Lnd_2(2)], 'g--', 'linewidth', 1 );
%     end
% end
% xlim([0 inf]); close;

%% ----------- Validifiaction of Function ---------- %

% “odomORmocap” is a boolean flag : “1” - odometry, “0” - mo-cap
% T_w2c = GetTranslationMat(27, bag, 0);
% 
% X_w1 = K*T_w2c(1:3,:)*[Lnd_1;1];
% X_w2 = K*T_w2c(1:3,:)*[Lnd_2;1];
% 
% pix1 = X_w1(1:2)/X_w1(3)
% pix2 = X_w2(1:2)/X_w2(3)
% 
% hold on;
% scatter(pix1(1), pix1(2), 80, 'ro');
% scatter(pix2(1), pix2(2), 80, 'ro');
% hold off;
% manual_co = [269.6244  184.5233;  471.6521  199.9169];
% manual_co = ginput;
% hold on;
% scatter(manual_co(1,1), manual_co(1,2), 'b+')
% scatter(manual_co(2,1), manual_co(2,2), 'b+')

%% ------------------ 4. Triangulate a Landmark ------------------ %
% ------------- Extracting Images from Rosbag ------------- %
bag = rosbag('rosbag_ac.bag');
bag_imgs  = select(bag,'Topic','/camera/rgb/image_raw/compressed');
all_imgs = readMessages(bag_imgs);
%%
bag_point  = select(bag,'Topic','/camera/depth/points');
all_point = readMessages(bag_point);
ptcloud = rosmessage('sensor_msgs/PointCloud2')











%% ----------- Triangulation - 3 Images with L ------------- %
N_i = [1 32 96];

for i=1:length(N_i)
    figure(i); imshow( readImage( all_imgs{N_i(i)} ) );
    [pix_i(i,1), pix_i(i,2)]  = ginput;
end

[pix_1 pix_2 pix_3] = deal( pix_i(1,:), pix_i(2,:), pix_i(3,:) );
u = pix_i(:,1); v = pix_i(:,2);

%% --------- Reconstruction using Odometry / Mocap Triangulation --------- %
flag = 1;                               % Set for both methods                             
for j=1:2                               % 0 - Mo-cap, 1 - Odometry
    clear A b M 
    for i=1:length(N_i)
        % -------- Obtain SPECIFIC Transformation Matrix ------- %
        T_w2c = GetTranslationMat(N_i(i), bag, j-flag);
        M = K*T_w2c(1:3,:);              % M : Projection Matrix
        % ------------- Form A x = b linear system ------------- %
        b( (2*i-1):(2*i),1) = [-u(i)*M(3,4) + M(1,4); -v(i)*M(3,4) + M(2,4) ];
        
        A( (2*i-1):(2*i),:) = [u(i)*M(3,1)-M(1,1),  u(i)*M(3,2)-M(1,2),  u(i)*M(3,3)-M(1,3);
            v(i)*M(3,1)-M(2,1),  v(i)*M(3,2)-M(2,2),  v(i)*M(3,3)-M(2,3)];
    end
    
    if j-flag == 0
        X_Mo_cap = inv(A'*A)*A'*b
        err_Mo_cap = norm( Lnd_2 - X_Mo_cap )
    else
        X_Odom = inv(A'*A)*A'*b
        err_Odom   = norm( Lnd_2 - X_Odom   )
    end
end

%% ---------- 3D Presentation of Triangulation points ---------- %
hold on; grid on;
plot3([3.794 3.794], [1.495 1.495], [0 0.5], 'k--', 'LineWidth', 1.5);
scatter3(X_Mo_cap(1), X_Mo_cap(2), X_Mo_cap(3), 'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75] );
scatter3(X_Odom(1), X_Odom(2), X_Odom(3), 'MarkerEdgeColor','k','MarkerFaceColor', 'r' );
scatter3(Lnd_2(1), Lnd_2(2), Lnd_2(3), 'MarkerEdgeColor','k','MarkerFaceColor', 'b' );

ind(1) = xlabel('X axis');
ind(2) = ylabel('Y axis');
ind(3) = zlabel('Z axis');
xlim([0 5]); ylim([0 3]); zlim([0 0.5]);
ind(4) = title('Triangulation of 3D points in ANPL');
ind(5) = legend('Mo-cap', 'Odometry', 'True');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
view([-39 34]);

%% --------------- 5.a.b The importance of diversity --------------- %
% --------------------- Load Data Automatically --------------------- %
r1 = [5 18 20]; r2 = [24 26 27]; r3 = [30 32 34]; r4 = [96 100 115];
N_i = [r1; r2; r3; r4];
load('u_5'); load('v_5');

flag = 0;                                % 0 - Mo-cap, 1 - Odometry
for k=1:4
    for i=1:3
        % --------- Manual pixel input : used only once -------- %
%         figure(i); imshow( readImage( allMsgs{N_i(k,i)} ) );
%         [u(k,i), v(k,i)] = ginput;
        % -------- Obtain SPECIFIC Transformation Matrix ------- %
        T_w2c = GetTranslationMat(N_i(k,i), bag, flag);
        M = K*T_w2c(1:3,:);                  % M : Projection Matrix
        run_i(3*(k-1)+i) = N_i(k,i);
        % ------------- Form A x = b linear system ------------- %
        b( (2*(i+k-1)-1):(2*(i+k-1)),1) = [-u(k,i)*M(3,4) + M(1,4); -v(k,i)*M(3,4) + M(2,4) ];
        
        A( (2*(i+k-1)-1):(2*(i+k-1)),:) = [u(k,i)*M(3,1)-M(1,1),  u(k,i)*M(3,2)-M(1,2),  u(k,i)*M(3,3)-M(1,3);
            v(k,i)*M(3,1)-M(2,1),  v(k,i)*M(3,2)-M(2,2),  v(k,i)*M(3,3)-M(2,3)];
        
        if flag == 0
            X_Mo_cap_i(:,3*(k-1)+i) = inv(A'*A)*A'*b;
            err_Mo_cap(3*(k-1)+i) = norm( Lnd_2 - X_Mo_cap_i );
        else
            X_Odom_i(:,3*(k-1)+i) = inv(A'*A)*A'*b;
            err_Odom(3*(k-1)+i)   = norm( Lnd_2 - X_Odom_i   );
        end
    end
    
    if flag == 0
        X_Mo_cap = inv(A'*A)*A'*b;
        err_Mo_cap(k) = norm( Lnd_2 - X_Mo_cap );
    else
        X_Odom = inv(A'*A)*A'*b;
        err_Odom(k)   = norm( Lnd_2 - X_Odom );
    end
end

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
ind(4) = legend('Odometry','Mo-cap');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
