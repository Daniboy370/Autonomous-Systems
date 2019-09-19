function [qnb, vn, pos] = sins(qnb_1, vn_1, pos_1, wm, vm, ts)
    tss = ts*size(wm,2);
    [phim,dvbm] = cnscl(wm, vm);
    [wnie, wnen, gn, retp] = earth(pos_1, vn_1);
    wnin = wnie+wnen;
    vn = vn_1 + qmulv(rv2q(-wnin*(1.0/2*tss)),qmulv(qnb_1,dvbm)) ...
        + (gn-cross(wnie+wnin,vn_1))*tss;
    vn1_1 = (vn+vn_1)/2;
    pos = pos_1 + tss*[vn1_1(2)/retp.rmh;vn1_1(1)/(retp.rnh*retp.cl);vn1_1(3)];
    qnb = qmul(qnb_1, rv2q(phim - qmulv(qconj(qnb_1),wnin*tss)));