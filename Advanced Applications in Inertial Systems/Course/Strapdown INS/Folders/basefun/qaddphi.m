function qpb = qaddphi(qnb, phi)
    qpb = qmul(rv2q(-phi),qnb);
