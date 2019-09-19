function qpb = qaddafa(qnb, afa)
%     qpb = qmul(rv2q(-phi),qnb);
    qpb = qmul(qconj(a2qnb(afa)), qnb);
