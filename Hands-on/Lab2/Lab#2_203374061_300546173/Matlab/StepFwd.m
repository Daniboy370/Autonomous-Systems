function [] = StepFwd(step,OdoSub,VelPub)
% This function makes the Pioneer robot mover forward, a specified distance
global rate robot_path b robot_az c
    odo1 = receive(OdoSub,2);   % Recieve odometry
    t0 = odo1.Header.Stamp.Sec; % Initial time
    a=1;    % index
    vCmd = 0;    % Initial velocity command
    maxErr = 0.01;  % Permitted step error (epsilon)
    r = odo1.Pose.Pose.Position;
    R0 = [r.X r.Y r.Z]'; % Starting Position
    while(1)
        odo1 = receive(OdoSub,2);   % Recieve odometry
        pause(rate)
        r = odo1.Pose.Pose.Position;
        R1 = [r.X r.Y r.Z]'; % Current position
        %Recording:
        robot_path(:,b) = R1;
        b=b+1;
        r = odo1.Pose.Pose.Orientation;
        ang = [r.X r.Y r.Z r.W]; % Current orientation
        ang = ang./norm(ang);
        ang = quat2eul(ang,'XYZ');                % Conver to Euler angles
        robot_az(1,c) = ang(1);
        t1 = odo1.Header.Stamp.Sec; % Current timestamp
        robot_az(2,c) = t1;
        c=c+1;
        % /Recording
        disp(R1);
        Err(a) = step - norm(R1-R0);  % Remaining distance to complete step
        if abs(Err(a)) < maxErr
            SafetyHalt(VelPub);
            return;                      % If we've completed the step, break
        end
        t1 = odo1.Header.Stamp.Sec; % Current timestamp
        dt = t1-t0;           % Time step
        if dt<1
            dt=0.5;
        end
        t0=t1;                % Remember previous timestamp
        vCmd = PD_Block([0.6 0.05 100]',dt,Err,vCmd); % Calculate velocity command
        if abs(vCmd) > 1           % Verify velocity command does not exceed permitted maximum
            vCmd = 1*sign(vCmd);
        end
        vCmd_msg = rosmessage(VelPub);  % Create vel. cmd. message
        vCmd_msg.Linear.X = vCmd;       
        send(VelPub,vCmd_msg);          % Send velocity cmd. message to robot
        a=a+1;
        
    end
end

