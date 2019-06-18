close all
clear all
clc

Lnd_2 = [3.794 1.495 0.3]';
load('cameraParams');
K = cameraParams.IntrinsicMatrix';
%% -------------------- 2.a Binary Table -------------------- %
load('Img_Corr'); N_msgs = 121;
% ------------ 2.b Estimated Path of the Robot -------------- %
bag = rosbag('rosbag_ac.bag');
bag_GT  = select(bag,'Topic','/Robot_1/pose');
all_GT_Msgs = readMessages(bag_GT);
bag_est = select(bag,'Topic','/RosAria/pose');
all_est_Msgs = readMessages(bag_est);

N_msgs = 121;
%% --------------- Extract Paths out of Files --------------- %

for i=1:N_msgs
    c_est = all_est_Msgs{i}.Pose.Pose.Position;
    [P_est(i,1), P_est(i,2)] = deal( c_est.X, c_est.Y );
    c_GT = all_GT_Msgs{i}.Pose.Position;
    [P_GT(i,1), P_GT(i,2)] = deal( c_GT.X, c_GT.Y );
end
pos_Deviat = P_GT(1,1:2);
P_GT_fix = P_GT - ones(N_msgs,1)*pos_Deviat;
Rot_mocap = angle2dcm( 0, 0, -deg2rad(90.6), 'XYZ');
P_GT_fix = transpose(Rot_mocap*[P_GT_fix zeros(N_msgs,1)]');

%% Pose Errors:
for a=1:N_msgs
    Pose_err(a) = norm(P_GT_fix(a) - P_est(a));
end
figure(1)
hold on
plot(1:N_msgs,Pose_err, 'b', 'linewidth', 2)
plot([22 22],[0 0.34],'k--')
plot([36 36],[0 0.34],'k--')
grid on
box on
xlabel('Image Number');
ylabel('Position Error [m]');
set(gca,'FontSize', 16 );
title('Robot Position Error','FontSize',20);
%% ------------------ 4. Triangulate a Landmark ------------------ %
% ------------- Extracting Images from Rosbag ------------- %
bag_imgs  = select(bag,'Topic','/camera/rgb/image_raw/compressed');
all_imgs = readMessages(bag_imgs);
% for i=22:36
%     imshow( readImage( all_imgs{i} ) );
%     [pix_i(i,1), pix_i(i,2)]  = ginput;
%     close all
% end
load('lanVar');

u = pix_i(:,1);
v = pix_i(:,2);
%% --------- Reconstruction using Odometry / Mocap Triangulation --------- %
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

%%

figure(1); hold on; grid on; box on;
plot(WND(23:36), err_Odom(23:36), 'b-', 'LineWidth', 2);
ind_1(2) = xlabel('Weighted Normalized Difference');
ind_1(3) = ylabel('3D Triangulation Error [m]');
set(gca,'FontSize', 16 );
ind_1(4) = title('3D Triangulation Error Vs. WND','FontSize',20);ind_1(1) = title('Geographic Coordinates vs. Step');
ind_1(5) = legend('$\phi$', '$\lambda$', 'h');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 14 );

