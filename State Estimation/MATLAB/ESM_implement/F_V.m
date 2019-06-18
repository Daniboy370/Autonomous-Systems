function dV = F_V(phi, h, dP_i, V_i)
% -------------------------- Dynamic Matrix -------------------------- %
global Re omg_ie g f_ib_b T_b_n

Rm = Re*(1-e^2)/(1-(e^2)*sin(phi)^2)^1.5;    % Normal Radius
Rn = Re/(1-(e^2)*sin(phi)^2)^0.5;            % Meridian Radius

% ************** Velocity Error States ************** %
Fvr = [ -2*V_i(2)*omg_ie*cos(phi)-(V_i(2)^2)/( (Rn+h)*cos(phi)^2 ), 0
    -(Vd*V_i(1))/(Rm+h)^2+(V_i(2)^2*tan(phi))/(Rn+h)^2;
    2*omg_ie*(-Vd*sin(phi)+V_i(1)*cos(phi))+(V_i(1)*V_i(2))/( (Rn+h)*cos(phi)^2 )
    0,  -(Vd*V_i(1))/(Rn+h)^2 - (Vd*V_i(2)*tan(phi))/(Rn+h)^2;
    2*V_i(2)*omg_ie*sin(phi), 0, (V_i(1)/(Rm+h))^2+(V_i(2)^2/(Rn+h))^2-2*g/(Re+h)];

Fvv = [ Vd/(Rm+h) -2*V_i(2)*tan(phi)/(Rn+h)-2*omg_ie*sin(phi)  V_i(1)/(Rm+h);
    2*omg_ie*sin(phi)+V_i(2)*tan(phi)/(Rn+h)  (Vd+V_i(1)*tan(phi) )/(Rn+h)
    2*omg_ie*cos(phi)+V_i(2)*tan(phi)/(Rn+h);
    -2*V_i(1)/(Rm+h)   (-2*omg_ie*cos(phi)-2*V_i(2)/(Rn+h)) 0];

f_in_n = T_b_n*f_ib_b;
Fve = -skew_symmetric(f_in_n);

% ***************** Function Output ***************** %
dV = [Fvr Fvv Fve];
end