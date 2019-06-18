function g_res = g_func( phi, h )
global e f
% ----------------- Constants ---------------- %
g = 9.780327;
R0 = 6.378388e6;
% --------------- Calculations --------------- %
theta = atan2(tan(phi)*(1-f)^2,0);
Re = R0*(1-e*(sin(theta))^2);
g_res = g*(1+0.0053024*(sin(phi))^2)*(1-2*(h/Re));

end