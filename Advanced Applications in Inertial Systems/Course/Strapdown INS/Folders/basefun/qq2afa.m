function afa = qq2afa(qpb, qnb)
% 与qq2phi的区别是,这里afa是与转动次序有关的欧拉平台误差角
    dQ = qmul(qnb, qconj(qpb));
    afa = q2att(dQ);
