function Cnb = dv2atti(vn1, vn2, vb1, vb2)
% Cnb = dv2atti(gn, wnie, -fb, wb);
    vb1 = norm(vn1)/norm(vb1)*vb1;
    vb2 = norm(vn2)/norm(vb2)*vb2;
    vntmp = cross(vn1,vn2);
    vbtmp = cross(vb1,vb2);
    Cnb = [vn1'; vntmp'; cross(vntmp,vn1)']^-1 * [vb1'; vbtmp'; cross(vbtmp,vb1)'];
%     Cnbk = Cnb;
%     for k=1:5
%         Cnbk = Cnbk - 0.5 * (Cnbk*Cnb'*Cnbk - Cnb);
%     end
%     Cnb = Cnbk;
    for k=1:5
        Cnb = 0.5 * (Cnb + (Cnb')^-1);
    end
