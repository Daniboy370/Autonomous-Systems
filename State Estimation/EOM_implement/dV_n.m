function dV = dV_n(phi, h, V_n)
%% *********************** d_Velocity *********************** %
global T_b_n i
global omg_ie Omg_en_n Omg_ie_n g_n f_ib_b Rm Rn

omg_en_n = [ V_n(2)/(Rn+h) -V_n(1)/(Rm+h) -V_n(2)*tan(phi)/(Rn+h)]';
Omg_en_n = skew_symmetric(omg_en_n);

omg_ie_n = omg_ie*[cos(phi) 0 -sin(phi)]';
Omg_ie_n = skew_symmetric(omg_ie_n);

dV = T_b_n(:,:,i)*f_ib_b + g_n -( Omg_en_n + 2*Omg_ie_n )*V_n;  % Velocity Derivative Matrix

end