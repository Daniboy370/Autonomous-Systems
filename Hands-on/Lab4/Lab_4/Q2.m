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

% ---------------- Sorting and fitting Plots ---------------- %
hold on; pbaspect([1 1 1]);
plot(P_est(:,1), P_est(:,2), 'linewidth', 2.5 );
pos_Deviat = ones(N_msgs,1)*P_GT(1,1:2);
P_GT_fix = P_GT - pos_Deviat;
Rot_mocap = angle2dcm( 0, 0, -deg2rad(90.6), 'XYZ');
P_GT_fix = transpose(Rot_mocap*[P_GT_fix zeros(N_msgs,1)]');
plot(P_GT_fix(:,1), P_GT_fix(:,2), 'linewidth', 2.5  )

scatter(Lnd_1(1), Lnd_1(2), 300, 'k*');
scatter(Lnd_2(1), Lnd_2(2), 300, 'k*');

for i=1:N_msgs
    if Img_Corr(i,1) == 1 && Img_Corr(i,2) == 1
        plot([P_est(i,1) Lnd_1(1)], [P_est(i,2) Lnd_1(2)], 'g--', 'linewidth', 1 );
        plot([P_est(i,1) Lnd_2(1)], [P_est(i,2) Lnd_2(2)], 'g--', 'linewidth', 1 );
    elseif Img_Corr(i,1) == 1 && Img_Corr(i,2) == 0
        plot([P_est(i,1) Lnd_1(1)], [P_est(i,2) Lnd_1(2)], 'g--', 'linewidth', 1 );
    elseif Img_Corr(i,2) == 1 && Img_Corr(i,1) == 0
        plot([P_est(i,1) Lnd_2(1)], [P_est(i,2) Lnd_2(2)], 'g--', 'linewidth', 1 );
    end
end

legend('Estimated Pioneer Path','Ground Truth','Landmark #1','Landmark #2')
title('Estimated Vs. Ground-Truth of Robot Path','FontSize','20')