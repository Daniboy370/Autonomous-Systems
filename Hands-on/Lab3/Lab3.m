clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);

%% -------------- List of given waypoints -------------- %
start = [0 0 0];
WP_1.pos  = [1.244 0 0];        WP_1.or = deg2rad(45);
WP_2.pos  = [2.584 1.011 0];    WP_2.or = deg2rad(315);
WP_3.pos  = [3.568  0     0];   WP_3.or = deg2rad(0);
Target.pos = [4.69 0 0];        Target.or = deg2rad(135);
% ---------------- Given Landmarks ---------------- %
Lndmk1 = [2.656 1.83  0.3]';
Lndmk2 = [3.794 1.495 0.3]';
% --------------- Calibration Matrix -------------- %
load('camParams.mat');
K = cameraParams.IntrinsicMatrix';

% ------------ Processing Robot's Images ---------- %

bag = rosbag('rosbag_ac.bag');
bag_imgs = select(bag,'Topic','/camera/rgb/image_raw/compressed');
allMsgs = readMessages(bag_imgs);
N_img = 27;
image( readImage( allMsgs{N_img} ) );

bag_pos = select(bag, 'Topic', '/RosAria/pose');
pos_msgs = readMessages(bag_pos);
% --------------- Acquiring Data from Robot --------------- %
R = pos_msgs{N_img}.Pose.Pose.Position;
pos = [R.X R.Y R.Z]';
Or = pos_msgs{N_img}.Pose.Pose.Orientation;
angle = quat2eul([Or.X Or.Y Or.Z Or.W]);
psi = angle(3);

t_1 = Lndmk1 - pos;
t_2 = Lndmk2 - pos;

% ----------- Display on image itself the relevant data ----------- %
hold on;
% manual_co = [269.6244  184.5233;  471.6521  199.9169]; 
manual_co = ginput;
scatter(manual_co(1,1), manual_co(1,2), 'b+')
scatter(manual_co(2,1), manual_co(2,2), 'b+')

%% ----------- Project on Camera Frame ----------- %
% ----------- Camera to Robot ----------- %
R_r2c = angle2dcm(pi/2,0,0)*angle2dcm(0,0,pi/2);
t_r2c = [0.08 0.08 -0.15]';
T_r2c = [R_r2c' t_r2c; 0 0 0 1];
% ----------- World to Camera ----------- %
R_w2r = angle2dcm(0,0,psi,'xyz');
t_w2r = R_w2r*(-pos);                     % Important -> translation |V_r|w_r 
T_w2r = [R_w2r t_w2r; 0 0 0 1];
% ----------- World to Camera ----------- %
T_w2c = T_r2c*T_w2r;

% ----------- Project pixels ------------ %
X_w1 = K*T_w2c(1:3,:)*[Lndmk1;1];
X_w2 = K*T_w2c(1:3,:)*[Lndmk2;1];

pix_1 = X_w1(1:2)/X_w1(3)
pix_2 = X_w2(1:2)/X_w2(3)

scatter(pix_1(1), pix_1(2), 80, 'ro');
scatter(pix_2(1), pix_2(2), 80, 'ro');

%% ------------------------------- Lab 4 ------------------------------- %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
% -------------------- 2.a Binary Table -------------------- %
load('Img_Corr'); N_imgs = 121;

% ------------ 2.b Estimated Path of the Robot ------------- %
bag = rosbag('rosbag_ac.bag');
bag_GT  = select(bag,'Topic','/Robot_1/pose');
all_GT_Msgs = readMessages(bag_GT);
bag_est = select(bag,'Topic','/RosAria/pose');
all_est_Msgs = readMessages(bag_est);

P_est = zeros(N_imgs, 2); P_GT = P_est;
% ------------ Extract Paths out of Files ------------ %
for i=1:N_imgs
cell_est = all_est_Msgs{i}.Pose.Pose.Position;
P_est(i,:) = [cell_est.X cell_est.Y cell_est.Z];

cell_GT = all_GT_Msgs{i}.Pose.Position;
P_GT(i,:) = [cell_GT.X cell_GT.Y cell_GT.Z];

end

% plot(P_est()





