function dX = dx(~, x)

global Re omg_ie e 
% ----------------- Assigning updated values ---------------- %
[phi, lambda, h] = deal(x(1), x(2), x(3) );
V_n              =     [x(4), x(5), x(6)]';
T_b2n = vec2mat( x(7:15), 3);
% ------------------ Geographic Coordinates ----------------- %
Rm = Re*(1-e^2)/(1-(e*sin(phi))^2)^1.5; % Normal Radius
Rn = Re/(1-(e*sin(phi))^2)^0.5;         % Meridian Radius

% ------------ Transformation to Navigation Frame ----------- %
g_n   = [0 0 g_func(phi, h)]';          % Calculated Gravitational Acceleration
T_n2b = T_b2n';
T_e2n = [   -sin(phi)*cos(lambda) -sin(phi)*sin(lambda)  cos(phi)    ;...
            -sin(lambda)          cos(lambda)            0           ;...
            -cos(phi)*cos(lambda) -cos(phi)*sin(lambda)  -sin(phi)   ];
        
%% ---------------------- Inertial Sensors ------------------- %
r_i = -0.1; r_f = 0.1; 
Exp = r_i + rand*(r_f-r_i);

% ----------------- Accelerometer Properties ----------------- %
f_true = T_n2b*(-g_n);                  % Accelerometer Measurements
w_a = [0,0,0]';                         % Accelerometer White Noise
b_a = [0,0,0]';                         % Accelerometer Bias
f_ib_b = f_true + w_a + b_a;            % Accelerometer Data (Total)

% --------------------- Gyro Properties ---------------------- %
omg_true = T_n2b*T_e2n*[0, 0, omg_ie]'; % Gyro Measurements
w_g = [0,0,0]';                       % Gyro White Noise
b_g = [0,0,0]';                         % Gyro Bias
omg_ib_b = omg_true + w_g + b_g;        % Gyro Data (Total)
Omg_ib_b = skew_symmetric(omg_ib_b);    % Skew Symmetric      

%% ----------------------- d_Position ------------------------ %
D  = [ 1/(Rm+h) 0                   0; 
       0        1/(cos(phi)*(Rn+h)) 0; 
       0        0                  -1];
% ---------- Assigning P_n(t) --------- %
dX(1:3) = D*[V_n(1) V_n(2) V_n(3)]';                     % P Result

%% ----------------------- d_Velocity ------------------------ %
omg_en2n = [ V_n(2)/(Rn+h) -V_n(1)/(Rm+h) -V_n(2)*tan(phi)/(Rn+h)]';
Omg_en2n = skew_symmetric(omg_en2n);
omg_ie2n = omg_ie*[cos(phi) 0 -sin(phi)]';
Omg_ie2n = skew_symmetric(omg_ie2n);

dV = T_b2n*f_ib_b + g_n -( Omg_en2n + 2*Omg_ie2n )*V_n;  % V Result

% --------- Assigning V_n(t) --------- %
dX(4:6) = [dV(1)  dV(2)  dV(3)]';

%% ----------------------- d_Orientation --------------------- %
dT_b_n = T_b2n*Omg_ib_b - ( Omg_ie2n + Omg_en2n )*T_b2n; % T Result

% -------- Assigning T_b_n(t) -------- %
dX(7:15) = reshape( dT_b_n', 9, 1);

% ------ Assigning State Vector ------ %
dX = dX';
