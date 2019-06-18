clc; close all; clear all; set(0,'defaultfigurecolor',[1 1 1]);
%% ************************ EOM - Navigation Frame ************************ %
% ---------- Global Parameters Initialization ------------ %
global Omg_ib_b f_ib_b omg_ie Re e g i   % Earth Parametes
global T_b_N g_n                       % Velocity Parametes

% ------- Initial Position [Geographic Coordinates] ------ %
Earth = wgs84Ellipsoid;                     % Earth's Reference Model 1984
% ------------- Locations for validification ------------- %
lat1 = 32.77611;      lon1 = 35.022366; % Technion
lat2 = 33.31522;      lon2 = 44.366071; % Baghdad <- (Desired Destination)

% ******************* Physical Properties ******************* %
i  = 1;                                 % Loop's index Initialization
h  = 0;                                 % Flight Altitude [m]
g  = 9.78;                              % Model's Gravitation [m/sec2]
Re = E.MeanRadius;                      % Planet Earth Mean Radius [m]
e  = E.Eccentricity;                    % Planet Earth Eccentricity
omg_ie = 2*pi/86400;                    % Earth's Angular Velocity [1/s]

%% -------------------------- Initial Conditions -------------------------- %
rr_0 = [1 1 1]';                        % 1 meter initial error [m]
vv_0 = [g g g]'*10^-3;                  % 1 mg initial error at each axis [m/s]
EE_0 = [1 1 1]'*(2*pi/360);             % 1 degree initial error at each axis [rad]

% ----- Initial Orientations (Assumption: Steady State ) ----- %
% phi_0 = deg2rad(lat1); lambda0 = deg2rad(lon1);  % I.C. of Meridians
phi_0 = pi/4; lambda_0 = 0;                 % Greenwich point
% [Dist, Az] = distance(phi_0, lambda_0, lat2, lon2, Earth, 'radians');
phi = phi_0; Eval_dist = 0;
% ----------------------- Euler Angles ----------------------- %
Phi  = 0; Theta = 0; Psi = 0;  % I.C. Euler angles [r,p,y]
            % --------- Small Angles Errors --------- %
d_Phi  = 0; d_Theta = 0; d_Psi = 0;  % I.C. Euler angles [r,p,y]
d_E = skew_symmetric(d_Phi, d_Theta, d_Psi);
eps_x = 0; eps_y = 0; eps_z = 0;            % Misalignment angles
E = [eps_x, eps_y, eps_z]';               % Misalignment Error
            % -------- T_b_n^ - Body to INS --------- %
T_b_N(:,:,i) = angle2dcm(Phi+d_Phi, Theta+d_Theta, Psi+d_Psi, 'xyz');
T_N_n = 
T_b_n = T_N_n*T_b_N(:,:,i) = 

T_b_ins = (eye(3) + E)*T_b_n;
% ------------------ Initial Body Kinemtics ------------------ %
Vx = 0;                              % Forward Speed   [m/sec]
Vy = 0;                                 % No Lateral Slip [m/sec]
Vz = 0;                                 % Constant Height [m/sec]
V_b = [Vx Vy Vz]';                      % Velocity in (Body)
V_n = T_b_n*V_b;                        % Velocity in (Navigation)
Vn=V_n(1); Ve=V_n(2); Vd=V_n(3);        % Assigning V_n Parameters

% ------------------- Initial Body Dynamics ------------------ %
g_n      = [0 0 g]';                    % Gravitational Acceleration
fx=0; fy=0; fz=-g;                      % No Accelereation (Steady State)
f_ib_b   = [fx fy fz]';                 % Accelerometer Measurements
omg_x=0; omg_y=0; omg_z=0;              % No Angular Vel.  (Steady State)
omg_ib_b = [omg_x omg_y omg_z]';        % Angular Velocity Vector (Body)
Omg_ib_b = skew_symmetric(omg_ib_b);    % In Skew Symmetric From

% -------------------- Memory Allocation --------------------- %
N = 1000;                               % N - Total Number of steps
dt   = 1;                               % dt = Integration step size
P_n  = [[phi_0 lambda_0 h]' zeros(3,N-1)];
V_n  = [V_n  zeros(3,N-1)];
Eval_dist = [Eval_dist; zeros(N-1,1)];

% ---------------- Step Promotion due to dt size--------------- %
for i=1:N-1
    drr_n(:,i+1) = rr_0(:,i) + dt*rr_n(phi, h, dP_i, V_i);
    
    dEE_n(:,i+1) = rr_0(:,i) + dt*EE(phi, h, dP_i, V_i);
    
    T_b_n(:,:,i+1) = T_b_n(:,:,i) + dt*dT_bn;
    % ------------ Update phi, Lambda and h values ------------ %
    phi = P_n(1,i+1);  lambda = P_n(2,i+1);  h = P_n(3,i+1);
    % ----- Calculte Distance between initial and final location ----- %
    [Dist, Az] = distance(phi, lambda, P_n(1,1), P_n(2,1), E, 'radians');
    Eval_dist(i+1) = Dist;
    % Break Condition - Stop when closest
%     if i>1 && ev_dist(i) > ev_dist(i-1)
%         ev_dist = ev_dist(1:i);
%         break;
%     end
end

%% ----------------------- Process & Visualization ------------------------ %
% ---------- Forming vectors in Degrees ------------ %
vec_phi = rad2deg( P_n(1,:)' );
vec_lam = rad2deg( P_n(2,:)' );
vec_h   = rad2deg( P_n(3,:)' );
km = 1000;
% ---- Note: using (i) instead of (N) for break condition ----- %

% --------- Geographic Coordinates vs Step --------- %
hold on; grid on;
plot(1:(i+1), vec_phi, '-', 1:(i+1), vec_lam, '-','LineWidth', 1.5)
ind(1) = title('Geographic Coordinates Vs. Step');
ind(2) = xlabel('Steps Number');
ind(3) = ylabel('[deg]');
% ---------------- Distance vs Step ---------------- %
yyaxis right
plot(1:(i+1), Eval_dist/km, 'g-', 'LineWidth', 1.5);
ind(4) = ylabel('Distance [km]'); set(gca,'ycolor','b')
ind(5) = legend('$\phi$', '$\lambda$', 'Dist.');
set(ind, 'Interpreter', 'latex', 'fontsize', 14 );

% -------------- Height Level vs Step -------------- %
figure(2); hold on; grid on;
plot(1:(i+1), vec_h, '-');
ind(1) = title('Height Vs. Step');
ind(2) = xlabel('Steps Number');
ind(3) = ylabel('Height [m]');
set(ind, 'Interpreter', 'latex', 'fontsize', 14 ); 
