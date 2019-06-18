function Y = RK_4( X, F, h, IC )
% ----------------------- Runge Kutta Algorithm ----------------------- %
x_len = length(X);
Y(:,1) = IC;                        % Initial Value Problem

for i  = 1:x_len-1                  % Each K gets 2 rows state vector
    k1 = h*F( X(i)      , Y(:,i)       );
    k2 = h*F( X(i)+0.5*h, Y(:,i)+0.5*k1 );
    k3 = h*F( X(i)+0.5*h, Y(:,i)+0.5*k2 );
    k4 = h*F( X(i)+    h, Y(:,i)+    k3 );
    Y(:,i+1) = Y(:,i) + (1/6)*( k1 + 2*k2 + 2*k3 + k4 );
end