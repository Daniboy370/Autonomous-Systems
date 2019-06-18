%% EOM function
% This file contains the EOM - equations of motion.
% 

clc
% clear all
% close all

% constants
R_e         = 6378.1*1000; % earth radius [km]
e           = 0.016727;    % earth excentricity [-]
g           = 9.81;
g_n         = [0;0;g];

delta_t     = 1;
duration 	= 10000;
time_vec(1) = 0;


% variables and states
psi         = 0;
lambda      = 0;
alt         = 100;
pos         = [psi, lambda, alt]';
vel_n       = [10,0,0]'; % North, East, Down

fx          = 0;
fy          = 0;
fz          = -g;
f_ib_b      = [fx;fy;fz];

omega_x     = 0;
omega_y     = 0;
omega_z     = 0;
omega_ie    = 0; %7.2921150*10^-5; %rad/sec
T_b2n       =   eye(3); % zeros(3); %

orientation = [omega_x; omega_y; omega_z];

% equations

R_m = (R_e*(1-e^2))/ (1-e^2 *sin(pos(1))^2 )^(3/2); % Meridian radius
R_n = (R_e)/ (1-e^2 *sin(pos(1))^2 )^(1/2);         % Normal radius

D = [(1/(R_m + pos(3))),    0 ,                                 0;...
     0,                     1/(cos(pos(1)*(R_n + pos(3)))),     0;...
     0,                     0 ,                                 -1];
 
omega_vec_en2n = [    vel_n(2)                / (R_n + pos(3));...
                    - vel_n(1)                / (R_m + pos(3));...
                    -(vel_n(2)*tan(pos(1)))   / (R_n + pos(3))];
                
omega_vec_ie2n = [  omega_ie*cos(pos(1));...
                    0;...
                    -omega_ie*sin(pos(1))];

omg_ib_b = [  omega_x;...
                    omega_y;...
                    omega_z];

                
omega_m_en2n =	[0                  , -omega_vec_en2n(3),	omega_vec_en2n(2)   ;...
                 omega_vec_en2n(3)  ,          0        ,	-omega_vec_en2n(1)  ;...
                -omega_vec_en2n(2)  , omega_vec_en2n(1) ,           0           ];

omega_m_ie2n =	[0                  , -omega_vec_ie2n(3),	omega_vec_ie2n(2)   ;...
                 omega_vec_ie2n(3)	,          0        ,	-omega_vec_ie2n(1)  ;...
                -omega_vec_ie2n(2)  , omega_vec_ie2n(1) ,           0           ];
                    
omega_m_ib2b =  [0                  , -omg_ib_b(3),	omg_ib_b(2)   ;...
                 omg_ib_b(3)  ,          0        ,   -omg_ib_b(1)  ;...
                -omg_ib_b(2)  , omg_ib_b(1) ,           0           ];


for i = 1:delta_t:duration

    r_dot       = D*vel_n(:,i);

    v_dot       = T_b2n*f_ib_b + g_n - (omega_m_en2n + 2*omega_m_ie2n)*vel_n(:,i);

    T_dot_b2n   = T_b2n*omega_m_ib2b - (omega_m_ie2n + omega_m_en2n)*T_b2n;


    pos(:,i+1)      = pos(:,i)      + delta_t * r_dot;
    
    vel_n(:,i+1)    = vel_n(:,i)    + delta_t * v_dot;
    
    T_b2n           = T_b2n         + delta_t * T_dot_b2n;

    [orientation(1,i+1),orientation(2,i+1),orientation(3,i+1)] = dcm2angle(T_b2n);
    
    time_vec(i+1) = i;

end

%% position
figure(1)

subplot(3,2,1)
plot(time_vec,pos(1,:))
ylabel('latitude')
xlabel('time')
grid on
title('position vector')

subplot(3,2,3)
plot(time_vec,pos(2,:))
ylabel('longitude')
xlabel('time')
grid on

subplot(3,2,5)
plot(time_vec,pos(3,:))
ylabel('altitude')
xlabel('time')
grid on

%% orientation

subplot(3,2,2)
plot(time_vec,orientation(1,:))
ylabel('roll')
xlabel('time')
grid on
title('orientation vector')

subplot(3,2,4)
plot(time_vec,orientation(2,:))
ylabel('pitch')
xlabel('time')
grid on

subplot(3,2,6)
plot(time_vec,orientation(3,:))
ylabel('yaw')
xlabel('time')
grid on


