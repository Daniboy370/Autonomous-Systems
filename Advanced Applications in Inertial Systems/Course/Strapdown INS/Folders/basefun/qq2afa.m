function afa = qq2afa(qpb, qnb)
% ��qq2phi��������,����afa����ת�������йص�ŷ��ƽ̨����
    dQ = qmul(qnb, qconj(qpb));
    afa = q2att(dQ);
