function dr = dr_n(phi, h, V_n)
%% *********************** d_Position *********************** %
global Re e Rm Rn
Rm = Re*(1-e^2)/(1-(e^2)*sin(phi)^2)^1.5;    % Normal Radius
Rn = Re/(1-(e^2)*sin(phi)^2)^0.5;            % Meridian Radius

D  = [ 1/(Rm+h) 0                   0; 
       0        1/(cos(phi)*(Rn+h)) 0; 
       0        0                  -1];
   
dr = D*[V_n(1) V_n(2) V_n(3)]';              % Position Derivative Matrix

end