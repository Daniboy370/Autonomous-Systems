function Xk = large_phi_model(Xkk_1, tVar)
    % (afa, vn) = large_phi_model(afa_1, vn_1, wnin, fn, ts)
    wnin = tVar(1:3); fn = tVar(4:6); ts = tVar(7);
    afa = Xkk_1(1:3);
    I3 = eye(3);
    Cw = a2cwa(afa);
    Cnn = a2cnb(afa);
    afa = afa + Cw^-1*(I3-Cnn')*wnin*ts;
    vn = Xkk_1(4:6) + (I3-Cnn)*fn*ts;
    Xk = [afa; vn];
