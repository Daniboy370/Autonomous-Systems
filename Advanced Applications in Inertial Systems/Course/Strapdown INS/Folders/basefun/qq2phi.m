function phi = qq2phi(qpb, qnb)
    dQ = qmul(qnb, qconj(qpb));
    phi = q2rv(dQ);
