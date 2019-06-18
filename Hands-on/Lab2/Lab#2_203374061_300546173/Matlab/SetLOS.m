function [] = SetLOS(Az1,OdoSub,VelPub)
% this function turns the Pioneer robot around to a required azimuth
global rate b c robot_path robot_az
    odo = receive(OdoSub,2);   % Recieve odometry
    t0 = odo.Header.Stamp.Sec; % Initial time
    a=1;    % index
    vCmd = 0;    % Initial velocity command
    maxAzErr = deg2rad(0.5);  % Permitted angular error (epsilon)

    while(1)
        
        odo = receive(OdoSub,2);   % Recieve odometry
        pause(rate)
        r = odo.Pose.Pose.Orientation;
        ang = [r.X r.Y r.Z r.W]; % Current orientation
        ang = ang./norm(ang);
        ang = quat2eul(ang,'XYZ');                % Conver to Euler angles
        Az0 = ang(1);                       % current azimuth
        disp(rad2deg(Az0));
        Err(a) = Az1-Az0;                   % Azimuth difference
        disp(rad2deg(Err(a)))
        %Recording:
        rpos = odo.Pose.Pose.Position;
        R1 = [r.X r.Y r.Z]'; % Current position
        robot_path(:,b) = R1;
        b=b+1;
        robot_az(1,c) = Az0;
        t1 = odo.Header.Stamp.Sec; % Current timestamp
        robot_az(2,c) = t1;
        c=c+1;
        % /Recording
        if abs(Err(a))>pi                   % Ensure shortest turn
            if Err(a) > 0
                Err(a) = Err(a) - 2*pi;
            else
                Err(a) = Err(a) + 2*pi;
            end
        end
        if abs(Err(a)) < maxAzErr           % if required azimuth reched, break
            SafetyHalt(VelPub);
            return;
        end
        dt = t1-t0;                         % Time step
        if dt<1
            dt=0.5;
        end
        t0=t1;                              % Remember previous timestamp
        vCmd = PD_Block([0.5 0.001 200],dt,Err,vCmd); % Calculate angular velocity command
        if abs(vCmd) > 0.7           % Verify angular velocity command does not exceed permitted maximum
            vCmd = 0.7*sign(vCmd);
        end
        vCmd_msg = rosmessage(VelPub);      % Create velocity command message
        vCmd_msg.Angular.Z = -vCmd;
        send(VelPub,vCmd_msg);              % Send velocity command message to robot
        a=a+1;
    end
end