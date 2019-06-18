clc; close all; clear all; set(0,'defaultfigurecolor',[1 1 1]);
%% ************************ EOM - Navigation Frame ************************ %
% ---------- Global Parameters Initialization ------------ %
global Omg_ib_b omg_ie Re e g i   % Earth Parametes
global T_b_n g_n f_ib_b           % Velocity Parametes

% ------- Initial Position [Geographic Coordinates] ------ %
E = wgs84Ellipsoid;                     % Earth's Reference Model 1984

% ******************* Physical Properties ******************* %
i  = 1;                                 % Loop's index Initialization
h  = 0;                                 % Flight Altitude [m]
g  = 9.78;                              % Model's Gravitation [m/sec2]
Re = E.MeanRadius;                      % Planet Earth Mean Radius [m]
e  = E.Eccentricity;                    % Planet Earth Eccentricity
omg_ie = 2*pi/86400;                    % Earth's Angular Velocity [1/s]

% --------------------------- Initial Conditions -------------------------- %
% ----- Initial Orientations (Assumption: Steady State ) ----- %
% phi_0 = deg2rad(lat1); lambda0 = deg2rad(lon1);  % I.C. of Meridians
phi_0 = 0; lambda_0 = 0;                 % Greenwich point
% [Dist, Az] = distance(phi_0, lambda_0, lat2, lon2, E, 'radians');
phi = phi_0; Eval_dist = 0;             % Initialization of vectors
% ----------------- Initial T_b_n Condition ------------------ %
Phi  = 0; Theta = 0; Psi = deg2rad(0);  % I.C. Euler angles [r,p,y]
T_b_n(:,:,i) = angle2dcm(Phi,Theta,Psi,'xyz'); % Body to Navigation frame

% ------------------ Initial Body Kinemtics ------------------ %
Vx = 0;                                 % Forward Speed   [m/sec]
Vy = 0;                                 % No Lateral Slip [m/sec]
Vz = 0;                                 % Constant Height [m/sec]
V_b = [Vx Vy Vz]';                      % Velocity in (Body)
V_n = T_b_n*V_b;                        % Velocity in (Navigation)
Vn=V_n(1); Ve=V_n(2); Vd=V_n(3);        % <- Need global ?? Assigning V_n Parameters

% ------------------- Initial Body Dynamics ------------------ %
% ***** !! When vehicle accelerates : put inside Loop !! ***** %
g_n      = [0 0 g]';                    % Gravitational Acceleration
fx=0; fy=0; fz=-g;                      % Accelerometer (on Steady State)
f_ib_b   = [fx fy fz]';                 % <- Need global ?? Accelerometer Measurements
omg_x=0; omg_y=0; omg_z=0;              % <- Need global ?? No Angular Vel.  (Steady State)
omg_ib_b = [omg_x omg_y omg_z]';        % Angular Velocity Vector (Body)
Omg_ib_b = skew_symmetric(omg_ib_b);    % In Skew Symmetric From

% -------------------- Memory Allocation --------------------- %
N = 1200;                               % N - Total Number of steps
dt   = 1;                               % dt = Integration step size
r_n  = [[phi_0 lambda_0 h]' zeros(3,N-1)];
V_n  = [V_n  zeros(3,N-1)];
Eval_dist = [Eval_dist; zeros(N-1,1)];

% ---------------- Step Promotion as per dt size--------------- %
hold on;
for i=1:N-1
    
    X_n(:,i+1) = X_n(:,i) + 
    r_n(:,i+1) = r_n(:,i) + dt*dr_n(phi, h, V_n(:,i));
    V_n(:,i+1) = V_n(:,i) + dt*dV_n(phi, h, V_n(:,i));
    T_b_n(:,:,i+1) = T_b_n(:,:,i) + dt*dT_bn;
    % ------------ Update phi, Lambda and h values ------------ %
    phi = r_n(1,i+1);  lambda = r_n(2,i+1);  h = r_n(3,i+1);
    % ----- Calculte Distance between initial and final location ----- %
    [Dist, Az] = distance(phi, lambda, r_n(1,1), r_n(2,1), E, 'radians');
    Eval_dist(i+1) = Dist;
end

%% ----------------------- Process & Visualization ------------------------ %

% ---------- Forming vectors in Degrees ------------ %
vec_phi = rad2deg( r_n(1,:)' );
vec_lam = rad2deg( r_n(2,:)' );
vec_h   = rad2deg( r_n(3,:)' );
km = 1000;

% --------- Geographic Coordinates vs Step --------- %
hold on; grid on;
plot(1:(i+1), vec_phi, '-', 1:(i+1), vec_lam, '-','LineWidth', 2);
ind_1(1) = title('Geographic Coordinates Vs. Step');
ind_1(2) = xlabel('Steps Number');
ind_1(3) = ylabel('[deg]');

% ----------------- Height vs Step ----------------- %
yyaxis right; 
plot(1:(i+1), vec_h, 'g-', 'LineWidth', 1.5);
ind_1(4) = ylabel('Height [m]'); set(gca, 'ycolor', 'g');
ind_1(5) = legend('$\phi$', '$\lambda$', 'h');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 14 );

%% ---------------- Distance vs Step ---------------- %
figure(2); hold on; grid on;
plot(1:(i+1), Eval_dist/km, 'k-', 'LineWidth', 2);
ind_2(1) = title('Distance Vs. Step');
ind_2(2) = xlabel('Steps Number');
ind_2(3) = ylabel('Distance [km]');
set(ind_2, 'Interpreter', 'latex', 'fontsize', 14 ); 

%% -------------------- Extracion of Body Orientation -------------------- %
[Phi, Theta, Psi] = dcm2angle(T_b_n(:,:,:)); 
Phi = rad2deg(Phi);  
Theta = rad2deg(Theta); 
Psi = rad2deg(Psi);

figure(3); 
subplot(3,1,1)
hold on; grid on; box on;
ind_3(1) = title('$\phi$ Vs. Time');
ind_3(2) = xlabel('Time [sec]');
ind_3(3) = ylabel('$\phi$ $[^\circ]$');
plot(1:N, Phi);

subplot(3,1,2)
hold on; grid on; box on;
ind_3(4) = title('$\theta$ Vs. Time');
ind_3(5) = xlabel('Time [sec]');
ind_3(6) = ylabel('$\theta$ [$^\circ$]');
plot(1:N, Theta);

subplot(3,1,3)
hold on; grid on; box on;
ind_3(7) = title('$\psi$ Vs. Time');
ind_3(8) = xlabel('Time [sec]');
ind_3(9) = ylabel('$\psi$ [$^\circ$]');
plot(1:N, Psi);

set(ind_3, 'Interpreter', 'latex', 'fontsize', 14 ); 

%% ------------------------------- Junkyard ------------------------------- %
% ------------- Locations for validification ------------- %
% lat1 = 32.77611;      lon1 = 35.022366; % Technion
% lat2 = 33.31522;      lon2 = 44.366071; % Baghdad 
% lat2 = 32.91613;      lon2 = 35.292520; % Karmiel
% lat2 = 32.79034;      lon2 = 35.52942; % Tiberias
% lat2 = 32.51065;      lon2 = 35.00405; % Menashe