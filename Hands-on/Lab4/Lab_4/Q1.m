(a) We’ve selected image number 96 and loaded it into matlab:
%% Read image from ROSbag
ImgNr = 28;
bag = rosbag('rosbag_ac.bag')
bagselect1 = select(bag,'Topic','/camera/rgb/image_raw/compressed')
imgMsg = readMessages(bagselect1);
C = imgMsg{ImgNr}.Data;
fileID = fopen('test.jpg','w');
fwrite(fileID,C);
fclose(fileID);
imshow('test.jpg')

(b) We’ve not used “Ground Truth”, but odometry reading instead. 
We’ve defined the Transformations between “Global” and “Robot” frame,
and between “Robot” and “Camera” frame.

%% Calculate landmark location
bagselect2 = select(bag,'Topic','/RosAria/pose');
poseMsg = readMessages(bagselect2);
P = poseMsg{ImgNr}.Pose.Pose.Position;
alpha = poseMsg{ImgNr}.Pose.Pose.Orientation;
quat = [alpha.X alpha.Y alpha.Z alpha.W];
alpha = quat2eul(quat);
alpha = alpha(3);
Rob = [P.X P.Y 0]'; % Robot Position (Global)
Tg2r = angle2dcm(0,0,alpha,'XYZ');
Tg2r(:,4) = Tg2r*(-Rob);
Tg2r(4,:) = [0 0 0 1];
Tr2c = angle2dcm(0,0.5*pi,-0.5*pi,'XYZ'); % Rotation from Global to Camera
Tr2c(:,4) = [0.08 0.08 -0.15]'; % Translation from Camera to Robot in Camera Frame
Tr2c(4,:) = [0 0 0 1];
% Landmarks:
Landmark1 = [2.656 1.83 0.3]';
Landmark2 = [3.794 1.495 0.3]';

(c ) And derived their “2D” coordinates from the image:
%% Derive coordinates:
figure(1)
imshow('test.jpg')
hold on
[Px,Py]= ginput;
tru = scatter(Px,Py,80,'+','r');

(d) Projecting the 3D landmarks into the camera frame:
%% Project Coordinates:
K = [529.777 0 322;0 532.012 246;0 0 1]; % Calibration Matrix

% Projection Matrix:
Tg2c =Tr2c*Tg2r;
T = Tg2c(1:3,:);
M = K*T;

% Homogenous:
Landmark1(4) = 1;
Landmark2(4) = 1;
L(:,1) = M*Landmark1;
L(:,1) = L(:,1)./L(3,1);
L(:,2) = M*Landmark2;
L(:,2) = L(:,2)./L(3,2);
scatter(L(1,:),L(2,:),80,'+','b');	
set(gca,'Xlim',[0 900])

%% Re-Projection Error:
errx = Px' - L(1,:);
erry = Py' - L(2,:);
landErr1 = norm([errx(1) erry(1)])
landErr2 = norm([errx(2) erry(2)])