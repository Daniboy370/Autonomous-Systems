function [Cnb, qnb] = sv2atti(vn, vb)
% [Cnb, qnb] = dv2atti(gn, -fb);
    afa = acos(vn'*vb/norm(vn)/norm(vb));
    phi = cross(vb,vn);
    qnb = [cos(afa/2); sin(afa/2)*phi/norm(phi)];
    Cnb = q2cnb(qnb);
