clc; clear

% syms phi lambda real
phi=pi/4; 
lambda =-pi/4;

R_n_e = RotRzRyRx(0, -pi/2-phi, lambda);
R_e_n = R_n_e'
%
T_n_e = angle2dcm(0, -pi/2-phi, lambda, 'xyz');  % (ECEF to Navigation)
T_e_n = T_n_e'


