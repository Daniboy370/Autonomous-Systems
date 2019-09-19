
%% Load Scenario
clc; clear all; close all;
set(0, 'defaultfigurecolor', [1 1 1]);
addpath(genpath('Scenario_REF'));            % Add path library
load('Trajectory.mat'); Read_IMU_GPS;

%% Model of IMU errors
sigma_q      = 1e-4;
bias_Acc     = [1;1;0.1]*10e-3;
drift_Omega  = [0.1;0.1;1]*10e-4;
noise_Acc    = repmat(bias_Acc,[1,length(Acc)])' + sigma_q*randn(length(Acc),3);
noise_Omega  = repmat(drift_Omega,[1,length(Acc)])' + sigma_q*randn(length(Omega),3);
Acc(:,2:4)   = Acc(:,2:4) + noise_Acc;
Omega(:,2:4) = Omega(:,2:4) + noise_Omega;

% Ground truth states
RefTrajectory   = ReadTrajectoryData(Ref_data);
State_GT = [RefTrajectory.Lat;RefTrajectory.Long;RefTrajectory.Alt;RefTrajectory.V_NED;RefTrajectory.Euler];

% Model of GPS errors
dt_GPS = 0.1;
sigma_v         = [1/6e6;1/6e6;1];
GPS.Localiztion = [RefTrajectory.Lat;RefTrajectory.Long;RefTrajectory.Alt] + [sigma_v(1)*randn(2,length(RefTrajectory.time));sigma_v(3)*randn(1,length(RefTrajectory.time))];
GPS.Veloctity   = [RefTrajectory.V_NED];
H               = [1 0 0 0 0 0 0 0 0; 0 1 0 0 0 0 0 0 0; 0 0 1 0 0 0 0 0 0];

% Initial States
lat          = GPS.Localiztion(1,1);
long         = GPS.Localiztion(2,1);
alt          = GPS.Localiztion(3,1);
V_l          = RefTrajectory.V_NED(:,1);
psi          = RefTrajectory.Euler(3,1)';
teta         = RefTrajectory.Euler(2,1)';
phi          = RefTrajectory.Euler(1,1)';
C_bl(:,:,1)  = Euler2DCM([phi,teta,psi]);
x_hat_m(:,1) = [lat;long;alt;V_l(:,1);phi;teta;psi];
dt           = Time(2)-Time(1);
k            = dt_GPS/dt;               % ratio between Ref/GPS dt to IMU dt
Error(:,1)   = [1/6e6;1/6e6;1;zeros(6,1)]; % initial Error
dx_hat_p     = Error(:,1);              % initial dx_hat_p
P_p0          = diag([1e-13;1e-13;1;0.003;0.003;0.003;1e-7;1e-7;1e-6]);
P_p          =  P_p0; 	
l            = 0;                       % counter of GPS measurements
[RN, RM, Re] = Radius(lat(1));
[Pn,Pe,Pd,X,Y,Z] =  LLLN2NED(lat,alt,(lat-RefTrajectory.Lat(1)),long-RefTrajectory.Long(1),alt-RefTrajectory.Alt(1),RN,RM);


%% ------------------ Work Process Loop ------------------ %
for i=1:length(Time)-1
    %% Strap down
    
    [RN, RM, Re] = Radius(lat(i));
    g_l          = [0;0;9.780318*(Re/(Re+alt(i)))^2*(1+0.0052884*sin(lat(i))^2-0.0000059*sin(2*lat(i))^2)];
    C_el         = [-sin(lat(i))*cos(long(i)), -sin(lat(i))*sin(long(i)), cos(lat(i))
        -sin(long(i)), cos(long(i)), 0
        -cos(lat(i))*cos(long(i)), -cos(lat(i))*sin(long(i)), -sin(lat(i))];
    w_ei         = [0;0;7.292115e-5];
    w_le         = [cos(lat(i))*V_l(2,i)/((RN + alt(i))*cos(lat(i))); -V_l(1,i)/ (RM + alt(i)); -sin(lat(i))*V_l(2,i)/((RN + alt(i))*cos(lat(i)))];
    w_li         = C_el*w_ei + w_le;
    C_pqr2l      = [1, sin(phi(i))*tan(teta(i)), cos(phi(i))*tan(teta(i)); 0, cos(phi(i)), -sin(phi(i)); 0, sin(phi(i))/cos(teta(i)), cos(phi(i))/cos(teta(i))];
    w_bl         = C_pqr2l * (Omega(i,2:4)' - C_bl(:,:,i)' * w_li);
    phi(i+1)     = phi(i) + w_bl(1)*dt;
    teta(i+1)    = teta(i) + w_bl(2)*dt;
    psi(i+1)     = psi(i) + w_bl(3)*dt;
    C_bl(:,:,i+1)=  Euler2DCM([phi(i+1),teta(i+1),psi(i+1)])';
    
    dV_l         = C_bl(:,:,i+1)*Acc(i,2:4)' + g_l - skew(w_le+2*C_el*w_ei)*V_l(:,i);
    V_l(:,i+1)   = V_l(:,i) + dV_l*dt;
    
    dlat         = V_l(1,i+1)/ (RM + alt(i));
    dlong        =  V_l(2,i+1)/((RN + alt(i))*cos(lat(i)));
    dalt         = -V_l(3,i+1);
    lat(i+1)     = lat(i) + dlat*dt;
    long(i+1)    = long(i) + dlong*dt;
    alt(i+1)     = alt(i) + dalt*dt;
    
    % curent state
    x_hat_m(:,i+1) = [lat(i+1);long(i+1);alt(i+1);V_l(:,i+1);phi(i+1);teta(i+1);psi(i+1)];
    
    % Error Model
    f    = Acc(i,2:4)';
    w    = Omega(i,2:4)';
    df   = bias_Acc*randn(1,1)+sigma_q*randn(3,1);%noise_Acc(i,:)';
    dw   = drift_Omega*randn(1,1)+sigma_q*randn(3,1);%noise_Omega(i,:)';
    du   = [df;dw];
    h    = alt(i+1);
    v_n  = V_l(1,i+1);
    v_e  = V_l(2,i+1);
    v_d  = V_l(3,i+1);
    Lat  = lat(i+1);
    f_n  = C_bl(:,:,i+1)*f;
    
    
    Fpp = [0, 0 -v_n/(RM+h)^2; v_e*sin(Lat)/(cos(Lat)^2*(RN+h)) 0 -v_e/(cos(Lat)*(RN+h)^2); 0 0 0];
    Fpv = [1/(RM+h) 0 0; 0 1/(cos(Lat)*(RN+h)) 0; 0 0 -1];
    Fpe = zeros(3,3);
    
    Fvp = [ -2*v_e*w_ei(3)*cos(Lat)-v_e^2/((RN+h)*cos(Lat)^2), 0, -v_d*v_n/(RM+h)^2+v_e^2*tan(Lat)/(RN+h)^2
        2*w_ei(3)*(-v_d*sin(Lat)+v_n*cos(Lat))+v_n*v_e/((RN+h)*cos(Lat)^2), 0, -v_d*v_n/(RM+h)^2-v_e*v_n*tan(Lat)/(RN+h)^2
        2*v_e*w_ei(3)*sin(Lat), 0, v_n^2/(RM+h)^2+v_e^2/(RN+h)^2-2*g_l(3)/(Re+h)];
    
    
    Fvv = [v_d/(RM+h), -2*v_e*tan(Lat)/(RN+h)-2*w_ei(3)*sin(Lat), v_n/(RM+h)
        2*w_ei(3)*sin(Lat)+v_e*tan(Lat)/(RN+h), v_d/(RN+h)+v_n*tan(Lat)/(RN+h), 2*w_ei(3)*cos(Lat)+v_e*tan(Lat)/(RN+h)
        -2*v_n/(RM+h), -2*w_ei(3)*cos(Lat)-2*v_e/(RN+h), 0];
    
    Fve = [0 f_n(3) -f_n(2); -f_n(3) 0  f_n(1); f_n(2) -f_n(1) 0];
    
    Fep = [w_ei(3)*sin(Lat), 0, v_e/(RN+h)^2; 0, 0, -v_n/(RM+h)^2; w_ei(3)*cos(Lat)+v_e/((RN+h)*cos(Lat)^2) 0 -v_e*tan(Lat)/(RN+h)^2];
    Fev = [0, -1/(RN+h), 0; 1/(RM+h) 0 0; 0 tan(Lat)/(RN+h) 0];
    Fee = [0,w_li(3), -w_li(2)
        -w_li(3), 0, w_li(1)
        w_li(2), -w_li(1), 0];
    F   = [Fpp Fpv Fpe; Fvp Fvv Fve; Fep Fev Fee];
    F_k = expm(F*dt); %eye(9)+F*dt;
    B   = [zeros(3,3), zeros(3,3); C_bl(:,:,i+1), zeros(3,3); zeros(3,3) C_bl(:,:,i+1)];
    
    % current error state
    Error(:,i+1) = F_k*Error(:,i) + B*du*dt;
    
    %% Extended Kalman Filter
    
    Q                   = B*sigma_q^2*B'*dt;
    if rem(i,k) == 0 % if got GPS measurement Use it for Estimate
        l= l+1;
        R               = diag(sigma_v)^2*dt_GPS;
        % Prediction
        dZ(:,l)         = H*x_hat_m(:,i+1)-GPS.Localiztion(:,i+1);
        dx_hat_m(:,l)    = Error(:,i+1);
        P_m             = F_k*P_p*F_k'+Q;
        % Correction
        K               = P_m*H'/(H*P_m*H'+R);
        dx_hat_p(:,l)   = dx_hat_m(:,l)+K*(dZ(:,l)-H*dx_hat_m(:,l));
        P_p             = (eye(9)-K*H)*P_m;
        
        % Update the current states
        x_hat_m(:,i+1)  = x_hat_m(:,i+1) - dx_hat_p(:,l);
        [lat(i+1),long(i+1),alt(i+1),V_l(1,i+1),V_l(2,i+1),V_l(3,i+1),phi(i+1),teta(i+1),psi(i+1)] = Update_States(x_hat_m(:,i+1));
        
        % Reset the error
        Error(:,i+1)    = zeros(9,1);
        
        % GPS XYZ
        [~,~,~,GPS_X(l),GPS_Y(l),GPS_Z(l)] =  LLLN2NED(GPS.Localiztion(1,i+1),GPS.Localiztion(2,i+1),(GPS.Localiztion(1,i+1)-RefTrajectory.Lat(1)),GPS.Localiztion(2,i+1)-RefTrajectory.Long(1),GPS.Localiztion(3,i+1)-RefTrajectory.Alt(1),RN,RM);
        
        % Monitoring Degree of Observability in GPS/INS Integration
        P_p_tag(:,:,l) = inv(sqrt(P_p0))*P_p*inv(sqrt(P_p0));
        P_p_tags(:,:,l) = length(P_p)* P_p_tag(:,:,l)/trace(P_p_tag(:,:,l));
        Eigenvalue(:,l) = eig(P_p_tags(:,:,l));
        
    else % else Update Only the Covriance
        P_p       = F_k*P_p*F_k'+Q;
    end
    sigmas(:,i+1) = sqrt(diag(P_p));
    
    % Position relative to the first Pose
    [Pn(i+1),Pe(i+1),Pd(i+1),X(i+1),Y(i+1),Z(i+1)] =  LLLN2NED(lat(i+1),alt(i+1),(lat(i+1)-RefTrajectory.Lat(1)),long(i+1)-RefTrajectory.Long(1),alt(i+1)-RefTrajectory.Alt(1),RN,RM);
    
end

%% IMU only(Dead Reckoning)
[SD_X,SD_Y,SD_Z] = StrapDown(Acc,Omega,Ref_data,Time);

%% ---------------- Analyze EKF Results ----------------- %
Error_EKF = x_hat_m-State_GT(:,1:end-1);
% Error_EKF = [lat-RefTrajectory.Lat(2:end);long-RefTrajectory.Long(2:end);alt-RefTrajectory.Alt(2:end);V_l-RefTrajectory.V_NED(:,2:end);[psi;teta;phi]-RefTrajectory.Euler(:,2:end)];
Error_norm = norm([RefTrajectory.X(end)-X(end);RefTrajectory.Y(end)-Y(end);RefTrajectory.Z(end)-Z(end)]);
fig_loc = [500 400 800 400];

%%  ----------------- Position results ------------------ %
figure('rend', 'painters', 'pos', fig_loc);
plot3(X,Y,Z,'r', 'linewidth', 1.5); hold on;
plot3(RefTrajectory.X,RefTrajectory.Y,RefTrajectory.Z, 'b', 'linewidth', 2);
ind(1) = title('Estimate vs Ground Truth');
ind(2) = ylabel('$Y [m]$');
ind(3) = xlabel('$X [m]$');
ind(4) = zlabel('$Z [m]$');
ind(5) = legend('$\hat{P}$', '$P_{GPS}$', 'location', 'northeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
grid on; clear ind;

%% ----------------- Strapdown results ------------------ %
figure('rend', 'painters', 'pos', fig_loc);
plot3(SD_X,SD_Y,SD_Z, 'r', 'linewidth', 1.5); hold on;
plot3(RefTrajectory.X,RefTrajectory.Y,RefTrajectory.Z, 'b', 'linewidth', 2)
ind(1) = title('Dead Reckoning vs Ground Truth');
ind(2) = ylabel('$Y [m]$');
ind(3) = xlabel('$X [m]$');
ind(4) = zlabel('$Z [m]$');
ind(5) = legend('$P_{DR}$', '$P_{GT}$', 'location', 'northeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
axis('equal'); grid on; view([-70 20]); clear ind;

%% ------------------ GPS measurements ------------------ %
figure('rend', 'painters', 'pos', fig_loc);
plot3(GPS_X,GPS_Y,GPS_Z,'.r', 'linewidth', 1.5); hold on;
plot3(RefTrajectory.X,RefTrajectory.Y,RefTrajectory.Z, 'b', 'linewidth', 2)
ind(1) = title('GPS vs Ground Truth');
ind(2) = ylabel('$Y [m]$');
ind(3) = xlabel('$X [m]$');
ind(4) = zlabel('$Z [m]$');
ind(5) = legend('$P_{GPS}$','$P_{GT}$', 'location', 'northeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 16 );
axis('equal'); grid on;  view([-25 16]); clear ind;

%% ------------------ IMU Measurments ------------------- %
figure('rend', 'painters', 'pos', fig_loc);
subplot(2,3,1); plot(Acc(:,1),Acc(:,2), 'linewidth', 3); title('Acc_x', 'fontsize', 11); grid on
subplot(2,3,2); plot(Acc(:,1),Acc(:,3), 'linewidth', 3); title('Acc_y', 'fontsize', 11); grid on
subplot(2,3,3); plot(Acc(:,1),Acc(:,4), 'linewidth', 0.2); title('Acc_z', 'fontsize', 11); grid on
subplot(2,3,4); plot(Omega(:,1),Omega(:,2), 'linewidth', 0.2); title('\omega_x', 'fontsize', 15); grid on
subplot(2,3,5); plot(Omega(:,1),Omega(:,3), 'linewidth', 0.2); title('\omega_y', 'fontsize', 15); grid on
subplot(2,3,6); plot(Omega(:,1),Omega(:,4), 'linewidth', 3); title('\omega_z', 'fontsize', 15); grid on

%% ---------------- p^n Error results ---------------- %
figure('rend', 'painters', 'pos', fig_loc); hold on;
% ----------------------------------- %
subplot(2,1,2); hold on;
plot(Time, Error_EKF(3, :), 'g', 'linewidth', 2);
plot(Time, sigmas(3, :) ,'r--', 'linewidth', 2);
ind(1) = legend('$\delta h$');
ind(2) = ylabel('Altitude [m]');
ind(3) = xlabel('Time [s]'); grid on;
xlim([0 Time(end)]);
% ----------------------------------- %
subplot(2,1,1); hold on;
plot(Time, Error_EKF(1, :), '-', 'linewidth', 1.5);
plot(Time, Error_EKF(2, :), '-', 'linewidth', 1.5);
plot(Time, sigmas(1, :) ,'r--', 'linewidth', 2);
ind(4) = title('$\delta p^n$ vs. time');
ind(5) = legend('$\delta \phi$', '$\delta \lambda$');
ind(6) = ylabel('Angle $[^\circ]$');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;

%% ---------------- v^N Error results ---------------- %
figure('rend', 'painters', 'pos', fig_loc); hold on;
plot(Time, Error_EKF(4, :), '-', 'linewidth', 2);
plot(Time, Error_EKF(5, :), '-', 'linewidth', 2);
plot(Time, Error_EKF(6, :), '-', 'linewidth', 2.5);
ind(1) = xlabel('Time [s]');
ind(2) = ylabel('Velocity $[{m}/{sec}]$');
ind(3) = title('$\delta v^n$ vs. time');
ind(4) = legend('$\delta v_N$', '$\delta v_E$', '$\delta v_D$', 'location', 'southeast');
a = get(gca, 'YTickLabel');
set(gca,'YTickLabel',a,'FontName','Times','fontsize',13);
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;

%% -------------- Euler Error results -------------- %
figure('rend', 'painters', 'pos', fig_loc); hold on;
% yyaxis left;
plot(Time, Error_EKF(7, :), '-', 'linewidth', 2);
plot(Time, Error_EKF(8, :), '-', 'linewidth', 2);
ind(1) = ylabel('Angle $[^\circ]$');
yyaxis right;
plot(Time, Error_EKF(9, :), '-', 'linewidth', 2.5);
a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'FontName','Times','fontsize',12);
ind(2) = ylabel('Angle $[^\circ]$');
ind(3) = title('Euler angles error vs. time');
ind(4) = xlabel('Time [s]');
ind(5) = legend('$\delta \phi$', '$\delta \theta$',  '$\delta \psi$', 'location', 'southeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;

%% ---------------- p^n Observability results ---------------- %
Time_O = dt:dt_GPS:Time(end)-dt_GPS;
figure('rend', 'painters', 'pos', fig_loc); hold on;
% yyaxis left;
plot(Time_O, Eigenvalue(1, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(2, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(3, :), '-', 'linewidth', 3);
ind(1) = ylabel('Degree of $\mathcal{O}$');
ind(2) = title('DoO($p^n$) vs. time');
ind(3) = xlabel('Time [s]');
ind(4) = legend('$\mathcal{O}(\phi)$', '$\mathcal{O}(\lambda)$', '$\mathcal{O}(h)$', 'location', 'southeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;

%% ---------------- v^n Observability results ---------------- %

Time_O = dt:dt_GPS:Time(end)-dt_GPS;
figure('rend', 'painters', 'pos', fig_loc); hold on;
% yyaxis left;
plot(Time_O, Eigenvalue(4, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(5, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(6, :), '-', 'linewidth', 3);
ind(1) = ylabel('Degree of $\mathcal{O}$');
ind(2) = title('DoO($v^n$) vs. time');
ind(3) = xlabel('Time [s]');
ind(4) = legend('$\mathcal{O}(v_N)$', '$\mathcal{O}(v_E)$', '$\mathcal{O}(v_D)$', 'location', 'northeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;


%% ---------------- t_b^n Observability results ---------------- %

Time_O = dt:dt_GPS:Time(end)-dt_GPS;
figure('rend', 'painters', 'pos', fig_loc); hold on;
% yyaxis left;
plot(Time_O, Eigenvalue(7, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(8, :), '-', 'linewidth', 3);
plot(Time_O, Eigenvalue(9, :), '-', 'linewidth', 3);
ind(1) = ylabel('Degree of $\mathcal{O}$');
ind(2) = title('DoO(Euler) vs. time');
ind(3) = xlabel('Time [s]');
ind(4) = legend('$\mathcal{O}(\phi)$', '$\mathcal{O}(\theta)$', '$\mathcal{O}(\psi)$', 'location', 'northeast');
set(ind, 'Interpreter', 'latex', 'fontsize', 18 );
xlim([0 Time(end)]); grid on; clear ind;