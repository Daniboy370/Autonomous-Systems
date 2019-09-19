function Ft = getf_DR(qnb, vn, pos, fb, dim)
%��ϵͳ����Ft
global glv
[wnie, wnen, gn, retp] = earth(pos, vn);
sl = retp.sl; cl = retp.cl; tl = retp.tl; secl = 1/retp.cl; secl2 = secl^2;
f_RMh = 1/retp.rmh; f_RNh = 1/retp.rnh; f_RMh2 = f_RMh^2; f_RNh2 = f_RNh^2;
%%%
M1 = [0, -f_RMh, 0; f_RNh, 0, 0; f_RNh*tl, 0, 0];
Mp = [0, 0, 0; -glv.wie*sl, 0, 0; glv.wie*cl, 0, 0];
Mpp = [0, 0, vn(2)*f_RMh2; 0, 0, -vn(1)*f_RNh2; vn(1)*secl2*f_RNh, 0, -vn(1)*tl*f_RNh2];
M2 = Mp+Mpp;
M3 = askew(vn)*M1 - askew(2*wnie+wnen);
M4 = askew(vn)*(2*Mp+Mpp);
M5 = [0, f_RMh, 0; secl*f_RNh, 0, 0; 0, 0, 1];
M6 = [0, 0, -vn(2)*f_RMh2; vn(1)*secl*tl*f_RNh, 0, -vn(1)*secl*f_RNh2; 0, 0, 0];
S1 = -askew(wnie+wnen); S2 = askew(qmulv(qnb,fb));
o3 = zeros(3,3);   Cnb = q2cnb(qnb);
%%%%%  fi    dvn   dpos     eb       db
Ft = [ S1    M1    M2        -Cnb       o3
    S2    M3    M4         o3        Cnb
    o3    M5    M6         o3        o3
    zeros(6,15)                           ];

Ft = [Ft, zeros(15,4);          % ��ʿ����p84ʽ(5.3-6)
    M5*askew(vn), zeros(3,12), M6, M5*vn;
    zeros(1,19)];