function WND = getWND()
    % ------------------- Memory Allocation --------------------- %
P_est = zeros(121, 2); P_GT = P_est;

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
P_GT_fix = P_GT - ones(N_msgs,1)*pos_Deviat;

Rot_mocap = angle2dcm( 0, 0, -deg2rad(90.6), 'XYZ');
P_GT_fix = transpose(Rot_mocap*[P_GT_fix zeros(N_msgs,1)]');

r1 = [5 18 20]; r2 = [24 26 27]; r3 = [30 32 34]; r4 = [96 100 115];
N_i = [r1; r2; r3; r4];

for k=1:4
    for i=1:3
        run_i(3*(k-1)+i) = N_i(k,i);
    end
end

for a = 1:12
    WND(a) = norm(P_GT_fix(run_i(a)) - P_est(run_i(a)));
end
end

