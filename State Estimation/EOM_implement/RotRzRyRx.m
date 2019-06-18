function R = RotRzRyRx( phi, theta, psi)
% This function calculates the corresponding rotation matrix from body 
% position to global position, in Roll-Pitch-Yaw order

Rx = [  1           0          0      ;
        0	     cos(phi)    sin(phi) ;
        0       -sin(phi)   cos(phi) ];

Ry = [ cos(theta)   0     -sin(theta) ;
        0           1          0      ;
       sin(theta)   0      cos(theta)];

Rz = [ cos(psi)	  sin(psi)     0      ;
      -sin(psi)   cos(psi)     0      ;
        0           0          1     ];
    
R = Rz*Ry*Rx;    
   
end