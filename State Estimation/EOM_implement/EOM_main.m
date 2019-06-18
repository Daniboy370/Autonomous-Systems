clc; close all; clear all; set(0,'defaultfigurecolor',[1 1 1]);
global dt Re omg_ie e f

% -------- Physical Properties (Using MATLAB Library -------- %
i  = 1;                                 % Loop's index Initialization
E = wgs84Ellipsoid;                     % Earth's Reference Model 1984
Re = E.MeanRadius;                      % Planet Earth Mean Radius [m]
f  = E.Flattening;                      % Planet Earth Flattening Extent
e  = E.Eccentricity;                    % Planet Earth Eccentricity
omg_ie = 7.292115e-5;                   % Earth's Angular Velocity [1/s]

% -------------------- Initial Conditions ------------------- %
% phi_0 = deg2rad(lat1); lambda0 = deg2rad(lon1);  % I.C. of Meridians
phi_0 = deg2rad(0);                    % Initial Latitude Position
lambda_0 = deg2rad(0);                 % Initial Longitude Position
h = 1000;                               % Initial Altitude
P_0 = [phi_0 lambda_0 h]';              % Initialization of vector
% [Dist, Az] = distance(phi_0, lambda_0, lat2, lon2, E, 'radians');

% ----------------- Initial T_b_n Condition ------------------ %
Phi     = 0; Theta = 0; Psi = deg2rad(0);       % I.C. Euler angles [r,p,y]
T_b2n   = angle2dcm(Phi, Theta, Psi, 'xyz');     % Body to Navigation frame
T_b2n_0 = reshape(T_b2n, 9, 1);

% ------------------ Initial Body Kinemtics ------------------ %
Vx = 0;                               % Forward Speed   [m/sec]
Vy = 0;                                 % No Lateral Slip [m/sec]
Vz = 0;                                 % Constant Height [m/sec]
V_b = [Vx Vy Vz]';                      % Velocity - Body
V_n = T_b2n*V_b;                        % Velocity - Navigation
V_n_0 = V_n;

% ---------------- State Vector Implementation --------------- %
t_0 = 0; t_F = 1000; dt = 1;
N = ( t_F - t_0 )/dt;
t = linspace(t_0, t_F, N);
IC = [P_0; V_n_0; T_b2n_0];             % IC - IVP

F = @(tt,x) dx(tt,x);
X = RK_4( t, F, dt, IC );

% opts = odeset('RelTol',1e-12,'AbsTol',1e-12);
% [t,X] = ode45( F, [t_0 t_F], IC, opts); X = X';

%% ------------- Geographic Coordinates vs Step -------------- %
figure(1); hold on; grid on;
plot(t, rad2deg( X(1,:) ), 'b-', t, rad2deg( X(2,:) ), 'r-','LineWidth', 2);
ind_1(1) = title('Geographic Coordinates vs. Step');
ind_1(2) = xlabel('Time [sec]');
ind_1(3) = ylabel('[deg]');

% ----------------- Height vs Step ----------------- %
yyaxis right;
plot(t, X(3,:), 'g-', 'LineWidth', 1.5);
ind_1(4) = ylabel('Height [m]'); set(gca, 'ycolor', 'g');
ind_1(5) = legend('$\phi$', '$\lambda$', 'h');
set(ind_1, 'Interpreter', 'latex', 'fontsize', 14 );

%% -------------------- Extracion of Body Orientation --------------------- %
% ------------- Spanning Body Orientation Vectors ------------ %

for i=1:length(X)
    [Phi(i), Theta(i), Psi(i)] = dcm2angle( vec2mat( X(7:15,i), 3 ), 'xyz' );
end

figure(2);
subplot(3,1,1)
hold on; grid on; box on;
ind_2(1) = title('$\phi$ vs. Time');
ind_2(2) = xlabel('Time [sec]');
ind_2(3) = ylabel('$\phi$ $[^\circ]$');
plot(t, rad2deg( Phi ), 'LineWidth', 1.5);

subplot(3,1,2)
hold on; grid on; box on;
ind_2(4) = title('$\theta$ vs. Time');
ind_2(5) = xlabel('Time [sec]');
ind_2(6) = ylabel('$\theta$ [$^\circ$]');
plot(t, rad2deg( Theta ), 'LineWidth', 1.5);

subplot(3,1,3)
hold on; grid on; box on;
ind_2(7) = title('$\psi$ vs. Time');
ind_2(8) = xlabel('Time [sec]');
ind_2(9) = ylabel('$\psi$ [$^\circ$]');
plot(t, rad2deg( Psi ), 'LineWidth', 1.5);

set(ind_2, 'Interpreter', 'latex', 'fontsize', 14 );

%% ----------------------- Body Velocities vs. Time ----------------------- % 
figure(3);
subplot(3,1,1)
hold on; grid on; box on;
ind_3(1) = title('$V_N$ vs. Time');
ind_3(2) = xlabel('Time [sec]');
ind_3(3) = ylabel('$V_N$ $[\frac{m}{sec}]$');
plot(t, X(4,:), 'LineWidth', 1.5);

subplot(3,1,2)
hold on; grid on; box on;
ind_3(4) = title('$V_E$ vs. Time');
ind_3(5) = xlabel('Time [sec]');
ind_3(6) = ylabel('$V_E$ $[\frac{m}{sec}]$');
plot(t, X(5,:), 'LineWidth', 1.5);

subplot(3,1,3)
hold on; grid on; box on;
ind_3(7) = title('$V_D$ vs. Time');
ind_3(8) = xlabel('Time [sec]');
ind_3(9) = ylabel('$V_D$ $[\frac{m}{sec}]$');
plot(t, X(6,:), 'LineWidth', 1.5);

set(ind_3, 'Interpreter', 'latex', 'fontsize', 14 );

%% ---------------- Distance vs Step ---------------- %
% figure(2); hold on; grid on;
% plot(1:(i+1), Eval_dist/km, 'k-', 'LineWidth', 2);
% ind_3(1) = title('Distance Vs. Step');
% ind_3(2) = xlabel('Steps Number');
% ind_3(3) = ylabel('Distance [km]');
% set(ind_3, 'Interpreter', 'latex', 'fontsize', 14 );

%% ------------------------------- Junkyard ------------------------------- %
% ------------- Locations for validification ------------- %
% lat1 = 32.77611;      lon1 = 35.022366; % Technion
% lat2 = 33.31522;      lon2 = 44.366071; % Baghdad
% lat2 = 32.91613;      lon2 = 35.292520; % Karmiel
% lat2 = 32.79034;      lon2 = 35.52942; % Tiberias
% lat2 = 32.51065;      lon2 = 35.00405; % Menashe