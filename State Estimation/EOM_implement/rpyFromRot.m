function [psi, theta, phi] = rpyFromRot( R )
% This function calculates the corresponding euler angles out of an
% rotation matrix input, in Roll-Pitch-Yaw order

if ( R(3,1) ~= 1 && R(3,1) ~= -1 )         %&& R(3,1) != -1 )
    
    theta_1 = -asin( R(3,1) );
    psi_1 = atan2( R(3,2)/cos(theta_1) , R(3,3)/cos(theta_1) );
    phi_1 = atan2( R(2,1)/cos(theta_1) , R(1,1)/cos(theta_1) );
    theta = theta_1; psi = psi_1; phi = phi_1;
     
    % Mind that there are 2 identities for every abs( R(3,1) ) = 1
%     theta_2 = pi - theta_1;
%     psi_2 = atan2( R(3,2)/cos(theta_2) , R(3,3)/cos(theta_2) )
%     phi_2 = atan2( R(2,1)/cos(theta_2) , R(1,1)/cos(theta_2) )
%     theta = theta_2; psi = psi_2; phi = phi_2;
else
    phi = 0; % Initialize;
    if ( R(3,1) == -1 )
        theta = pi/2;
        psi = phi + atan2( R(1,2), R(1,3) );
    else
        theta = -pi/2;
        psi = -phi + atan2( -R(1,2), -R(1,3) );
    end
end