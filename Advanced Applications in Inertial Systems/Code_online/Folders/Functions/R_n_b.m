function T_n_b = R_n_b(phi, theta, psi)
% -------------------------- Description ------------------------- %
%                                                                  %
%               Convert body to Navigatgion frame                  %
%                                                                  %
% --------------------------- Content ---------------------------- %

Rx = [  1           0          0      ;
        0	     cos(phi)    sin(phi) ;
        0       -sin(phi)    cos(phi)];

Ry = [ cos(theta)   0     -sin(theta) ;
        0           1          0      ;
       sin(theta)   0      cos(theta)];

Rz = [ cos(psi)	  sin(psi)     0      ;
      -sin(psi)   cos(psi)     0      ;
        0           0          1     ];
    
T_n_b = Rz*Ry*Rx;

% T_n_b = Rx*Ry*Rz;

end
