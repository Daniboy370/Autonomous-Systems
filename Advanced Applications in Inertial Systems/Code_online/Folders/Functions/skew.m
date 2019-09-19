function [ M ] = skew( v )
%SKEW This function computes the skew matrix of a vector
M=[0 -v(3) v(2);
    v(3) 0 -v(1);
    -v(2) v(1) 0];
end

