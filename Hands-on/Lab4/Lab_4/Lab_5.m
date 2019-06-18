%% ------------------------------- Lab 5 ------------------------------- %
clc; clear all; close all; set(0,'defaultfigurecolor',[1 1 1]);
global K pos_Deviat

% ------------------------ Initialization ------------------------ %
Lnd_1 = [2.656 1.83  0.3]';
Lnd_2 = [3.794 1.495 0.3]';
load('cameraParams');
K = cameraParams.IntrinsicMatrix';

% ---------------------- Memory Allocation ----------------------- %
N_msgs = 121;
P_GT = zeros(N_msgs, 2);
pos_Deviat = P_GT(1,1:2);

%%  ----------------- Extract - Images along path ---------------- %
bag = rosbag('rosbag_ac.bag');
bag_imgs  = select(bag,'Topic','/camera/rgb/image_raw/compressed');
all_imgs = readMessages(bag_imgs);
imshow( readImage( all_imgs{96} ) );         % Show chosen image

%% -------------------- Point Cloud Extraction ------------------- %
bag = rosbag('rosbag_ac.bag');
bag_pc = select(bag,'Topic','/camera/depth/points');
all_pc = readMessages( bag_pc );

ptcloud = all_pc{97};                        % Approach chosen image
XYZ = readXYZ(ptcloud);                      % Read the XYZ Coordinates
XYZ_valid = XYZ(~isnan(XYZ(:,1)),:);         % Extract only valid ones
% rgb = readRGB(ptcloud);                    % Does not exist in our bag ?
figure
scatter3(ptcloud)

%% ----- Expand exraction across all images in bag ----- %

for i = 1:10
ptcloud(i).Data = all_pc{i};
XYZ(i).Data = readXYZ(ptcloud);
XYZ_valid(i).Data = XYZ(~isnan(XYZ(:,1)),:);
end
