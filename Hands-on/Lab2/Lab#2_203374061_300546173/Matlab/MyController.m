function [] = MyController(Goal,Odometry_Topic,Velocity_Topic)
    %% Initialization
    OdoSub = Odometry_Topic;    % Odometry subscriber
    VelPub = Velocity_Topic;  % Velocity command publisher
    epsLoc = 0.1;                              % Permitted location error
    step = 0.5;                                 % Step length [m]
    %% Movement
    while(1)
        odo = receive(OdoSub,2);           % Recieve odometry data
        r = odo.Pose.Pose.Position;
        Rc = [r.X r.Y r.Z]';  % Current Position
        LocErr = norm(Goal.loc - Rc);    % Current distance from goal [m]
        % Breaking Conditions
%         if (a>1)&&(LocErr(a) > LocErr(a-1)) % Break if error increases
%             SafetyHalt(VelPub);
%             return;
%         end
        if LocErr < epsLoc
            SetLOS(Goal.Orien,OdoSub,VelPub);   % If we've reached goal, turn to requested azimuth and break
            SafetyHalt(VelPub);
            return;
        end

        % Movement
        SetLOS(CalcLOS(Goal.loc,OdoSub),OdoSub,VelPub); % for each step, turn towards goal
        StepFwd(min(step,LocErr),OdoSub,VelPub);     % step forward
    end
end

