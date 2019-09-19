function [qnb, pos] = DR(qnb_1, pos_1, wm, dSb, ts)
    tss = ts*size(wm,2);
    dSn = qmulv(qnb_1, dSb);
    vn_1 = dSn/tss;
    [wnie, wnen, gn, retp] = earth(pos_1, vn_1);
    wnin = wnie+wnen;
    pos = pos_1 + tss*[vn_1(2)/retp.rmh;vn_1(1)/(retp.rnh*retp.cl);vn_1(3)];
    qnb = qmul(qnb_1, rv2q(cnscl(wm) - qmulv(qconj(qnb_1),wnin*tss)));
    
    
