%% Euler2DCM
function [ Euler_matrix ] = Euler2DCM(euler)
    phi=euler(1);
    theta=euler(2);
    psi=euler(3);
    Rx=[1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
    Ry=[cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
    Rz=[cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
    Euler_matrix=Rx*Ry*Rz;
end
