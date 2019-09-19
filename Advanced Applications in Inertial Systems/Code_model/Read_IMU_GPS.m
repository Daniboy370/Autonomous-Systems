clear;
IMU = load('circle_IMU.txt'); %circle_IMU.txt StandStill_IMU.txt walking_infinty_IMU.txt
ind_Time =3:7:72;
ind_Qv_x = 4:7:72;
ind_Qv_y = 5:7:72;
ind_Qv_z = 6:7:72;

ind_Qt_x = 7:7:72;
ind_Qt_y = 8:7:72;
ind_Qt_z = 9:7:72;
 
Time = [];
IMU_Qv_x = [];
IMU_Qv_y = [];
IMU_Qv_z = [];
IMU_Qt_x = [];
IMU_Qt_y = [];
IMU_Qt_z = [];

for j=1:length(IMU)
    Time = [Time,IMU(j,ind_Time)];
    IMU_Qv_x =[IMU_Qv_x,IMU(j,ind_Qv_x)];
    IMU_Qv_y =[IMU_Qv_y,IMU(j,ind_Qv_y)];
    IMU_Qv_z =[IMU_Qv_z,IMU(j,ind_Qv_z)];
    
    IMU_Qt_x =[IMU_Qt_x,IMU(j,ind_Qt_x)];
    IMU_Qt_y =[IMU_Qt_y,IMU(j,ind_Qt_y)];
    IMU_Qt_z =[IMU_Qt_z,IMU(j,ind_Qt_z)];
end

dT_mat = ones(3,1)*diff(Time);
Acc = [Time(1:end-1)',[IMU_Qv_x(1:end-1)',IMU_Qv_y(1:end-1)',IMU_Qv_z(1:end-1)']./dT_mat'];
Omega = [Time(1:end-1)',[IMU_Qt_x(1:end-1)',IMU_Qt_y(1:end-1)',IMU_Qt_z(1:end-1)']./dT_mat'];

Ref_data = load('circle_REF.txt'); % circle_REF.txt StandStill_REF.txt walking_infinty_REF.txt
save('Trajectory','Time','Acc','Omega','Ref_data');