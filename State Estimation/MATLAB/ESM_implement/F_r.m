function F = F_r(phi, h, dP_i, V_i)
% -------------------------- Dynamic Matrix -------------------------- %
global Re omg_ie g f_ib_b T_b_n

Rm = Re*(1-e^2)/(1-(e^2)*sin(phi)^2)^1.5;    % Normal Radius
Rn = Re/(1-(e^2)*sin(phi)^2)^0.5;            % Meridian Radius

% ************** Position Error States ************** %
Frr = [0 0 -V_i(1)/(Rm+h)^2;  V_i(2)*sin(phi)/(cos(phi)^2*(Rn+h)) 0
    -V_i(2)*sin(phi)/(cos(phi)^2*(Rn+h)); 0 0 0];
Frv = diag([1/(Rm+h)  1/(cos(phi)*(Rn+h))  -1]);
Fre = zeros(3);


% ************ Misalignment Error States ************ %
Fer = [ omg_ie*sin(phi)  0  V_i(2)/(Rn+h)^2; 0 0 -V_i(2)/(Rm+h)^2;
    omg_ie*cos(phi)+V_i(2)/( (Rn+h)*cos(phi)^2 ) 0 -V_i(2)*tan(phi)/(Rn+h)^2];

Fev = [0 -1/(Rn+h) 0; 1/(Rm+h) 0 0; 0 tan(phi)/(Rn+h) 0];

omg_in_n = T_b_n*omg_ib_b;
Fee = -skew_symmetric(omg_in_n);

% ***************** Function Output ***************** %
F = [Frr Frv Fre; Fvr Fvv Fve; Fer Fev Fee]; 

end