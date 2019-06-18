function T_global2cam = GetTranslationMat(FrameIndx, Database, odomORmocap)
global pos_Deviat

if odomORmocap == 1
    % ------ Fitting odometry to Robot Co. system ------- %
    bag_pos = select(Database, 'Topic', '/RosAria/pose');
    pos_msgs = readMessages(bag_pos);
    R_i = pos_msgs{FrameIndx}.Pose.Pose.Position;
    R = [R_i.X R_i.Y 0]; R = R';
    Or = pos_msgs{FrameIndx}.Pose.Pose.Orientation;
    angle = quat2eul([Or.X Or.Y Or.Z Or.W]); 
    psi = angle(3);
else % odomORmocap == 0
    % -------- Fitting mocap to Robot Co. system -------- %
    bag_pos = select(Database, 'Topic', '/Robot_1/pose');
    pos_msgs = readMessages(bag_pos);
    R_i = pos_msgs{FrameIndx}.Pose.Position;
    R_i = [R_i.X R_i.Y] - pos_Deviat;           % Initial Postion Deviation
    Rot_mocap = angle2dcm( 0, 0, -deg2rad(90.6), 'XYZ' );
    R = Rot_mocap*[R_i(1) R_i(2) 0]';
    Or = pos_msgs{FrameIndx}.Pose.Orientation; 
    angle = quat2eul([Or.X Or.Y Or.Z Or.W]);    
    psi = angle(3) + deg2rad(90.6);             % Initial Angular Deviation
end

% ---------------- Project on Camera Frame ---------------- %
% -------------- Transform : Camera to Robot -------------- %
R_r2c = angle2dcm(pi/2,0,0)*angle2dcm(0,0,pi/2);
t_r2c = [0.08 0.08 -0.15]';
T_r2c = [R_r2c' t_r2c; 0 0 0 1];
% -------------- Transform : World to Camera -------------- %
R_g2r = angle2dcm(0, 0, psi,'xyz');
t_g2r = R_g2r*(-R);
T_g2r = [R_g2r t_g2r; 0 0 0 1];
% ------- Output : Transformation Product ------- %
T_global2cam = T_r2c*T_g2r;
