function RefTrajectory=ReadTrajectoryData(Ref_data)
REF = Ref_data;

maxSteps = length(REF);

RefTrajectory = struct('time',[], 'Lat', [], 'Long', [], 'Alt', [], 'V_NED', [], 'V_b', [], 'Euler', []);
RefTrajectory.time  = REF(1:maxSteps,1)';                         %sec
RefTrajectory.Lat   = REF(1:maxSteps,2)';                         %rad
RefTrajectory.Long  = REF(1:maxSteps,3)';                         %rad
RefTrajectory.Alt   = REF(1:maxSteps,4)';                         %m
RefTrajectory.V_NED = [REF(1:maxSteps,5) REF(1:maxSteps,6) REF(1:maxSteps,7)]';    %m/sec
RefTrajectory.V_b   = [REF(1:maxSteps,8) REF(1:maxSteps,9) REF(1:maxSteps,10)]';   %m/sec
RefTrajectory.Euler = [REF(1:maxSteps,13) REF(1:maxSteps,12) REF(1:maxSteps,11)]'; %rad

for i=1:maxSteps
    [RN, RM, Re]     = Radius(RefTrajectory.Lat(i));
    [RefTrajectory.Pn(i),RefTrajectory.Pe(i),RefTrajectory.Pd(i),RefTrajectory.X(i),RefTrajectory.Y(i),RefTrajectory.Z(i)] =  LLLN2NED(RefTrajectory.Lat(i),RefTrajectory.Alt(i),(REF(i,2)-REF(1,2)),(REF(i,3)-REF(1,3)),(REF(i,4)-REF(1,4)),RN,RM);
    if RefTrajectory.Euler(3,i) < 0
        RefTrajectory.Euler(3,i) = RefTrajectory.Euler(3,i)+2*pi;
    end
        
end
%  R0                  = 6378137;
% north               = (REF(:,2)-REF(1,2))*R0;
% east                = (REF(:,3)-REF(1,3))*R0;
% Z                   = (REF(:,4)-REF(1,4));
% RefTrajectory.X     = east';                                                         %m
% RefTrajectory.Y     = north';                                                        %m
% RefTrajectory.Z     = Z';

