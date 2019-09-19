function [wnie, wnen, gn, retp] = earth(pos, vn)
global glv
    if nargin==1
        vn = [0; 0; 0];
    end
    sl=sin(pos(1)); cl=cos(pos(1)); tl=sl/cl; sl2=sl*sl; sl4=sl2*sl2;
    wnie = glv.wie*[0; cl; sl];
    sq = 1-glv.e2*sl2; sq2 = sqrt(sq);
    RMh = glv.Re*(1-glv.e2)/sq/sq2+pos(3);
    RNh = glv.Re/sq2+pos(3);
    wnen = [-vn(2)/RMh; vn(1)/RNh; vn(1)/RNh*tl];
    g = glv.g0*(1+5.27094e-3*sl2+2.32718e-5*sl4)-3.086e-6*pos(3); % grs80
    gn = [0;0;-g];
    retp.g = g;
    retp.sl = sl; retp.cl = cl; retp.tl = tl; retp.sl2 = sl2;
    retp.rmh = RMh; retp.rnh = RNh;
