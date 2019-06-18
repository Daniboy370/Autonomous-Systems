function [Az1] = CalcLOS(R1,OdoSub)
% This function calculates the required LOS for the Pioneer robot
    
    odo1 = receive(OdoSub,2);   % Recieve odometry

    r = odo1.Pose.Pose.Position;
    R0 = [r.X r.Y r.Z]'; % Current position
    Vec = R1-R0;                  % Delta to goal
    Az1 = -atan2(Vec(2),Vec(1));    % Goal azimuth
end