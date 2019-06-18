function C = skew_symmetric(V)
%% ************ Turn a 3D vector into a Skew Symmetric Matrix ************* %
C = [0    -V(3)  V(2); 
     V(3)  0    -V(1); 
    -V(2)  V(1)  0  ];
end