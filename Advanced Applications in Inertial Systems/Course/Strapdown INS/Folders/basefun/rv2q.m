function q = rv2q(rv)

norm = sqrt(rv'*rv);
if norm>1.e-20
    f = sin(norm/2)/(norm/2);
else
    f = 1;
end
q = [cos(norm/2); f/2*rv];
