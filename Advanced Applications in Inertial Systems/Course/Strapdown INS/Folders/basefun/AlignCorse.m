function [qnb, qnb0, wnck] = AlignCorse(wbib, fbsf, L, Ts)
% ���ƽ̨�ߵ����дֶ�׼
global glv
    llen = fix(4/Ts);
    qb0b = [1;0;0;0]; vb0 = [0;0;0];
    for k=1:llen 
        qb0b = qmul( qb0b, rv2q(wbib(k,:)'*Ts) );
        vb0 = vb0 + qmulv(qb0b, fbsf(k,:)')*Ts;
    end
    [Cnb0,qnb0] = sv2atti([0;0;glv.g0],vb0/(llen*Ts));   % ˮƽ�ֶ�׼4s
    qnb = qmul(qnb0,qb0b); %qnb = [1;0;0;0];
    
    len = length(wbib); t1 = fix(len*3/4);
    kxy = compasskxyz(len*Ts/2);
    qnb0 = qnb;
    wnie = glv.wie*[0; cos(L); sin(L)];
    wnck = zeros(len,3);
    [b,a] = foie(len/8*Ts, Ts);
    qnb = qnb0;
    vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % ״̬��ʼֵ
    for k=llen+1:len
        qnb = qmul( qnb, rv2q((wbib(k,:)'-qmulv(qconj(qnb),wnie+wnc))*Ts) );
        fn = qmulv(qnb, fbsf(k,:)');
        [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos);   % �����ƽ
        wnck(k,:) = -a(2)*wnck(k-1,:) + b(1)*wnc';
    end
    % �ӿ��ƽ������м��㷽λ�ǣ��ο��ҵĽ���2011��10.5.2��
    cphi = 1+mean(wnck(t1:len,2))/wnie(2); sphi = -mean(wnck(t1:len,1))/wnie(2);
    n_phi = sqrt(cphi^2+sphi^2); cphi = cphi/n_phi; sphi = sphi/n_phi;
    Cnn = [cphi sphi 0; -sphi cphi 0; 0 0 1]; qnn = m2qnb(Cnn);
    qnb = qmul(qnn,qnb); % ���� 
