function [Vel_command] = PD_Block(PD_const,samplingTime,err_vec,comm_vec)
%%

%% init
Kp = PD_const(1);
Kd = PD_const(2);
N = PD_const(3);

const1 = (N*Kp)/(N-1/samplingTime) + (Kp+Kd)/(N*samplingTime-1);
const2 = -(Kp+Kd)/(N*samplingTime-1);
const3 = 1/(N*samplingTime-1);
%% input check
if length(err_vec)<2
    err_vec = [0 ; err_vec];
    comm_vec = 0;
end

%% creating the vel command
Vel_command = const1*err_vec(end) + const2*err_vec(end-1) + const3*comm_vec(end);

end
