function [Phi, Qk] = kfdis(Ft, Qt, Tkf, n)

Tkfi = Tkf;
facti = 1;
Fti = Ft;
Mi = Qt;
In = eye(size(Ft,1));
Phi = In + Tkf*Ft;
Qk = Qt*Tkf;

for i=2:1:n
    Tkfi = Tkfi*Tkf;
    facti = facti*i;
    Fti = Fti*Ft;
    Phi = Phi + Tkfi/facti*Fti;
    
    FtMi = Ft*Mi;
    Mi = FtMi + FtMi';
    Qk = Qk + Tkfi/facti*Mi;
end