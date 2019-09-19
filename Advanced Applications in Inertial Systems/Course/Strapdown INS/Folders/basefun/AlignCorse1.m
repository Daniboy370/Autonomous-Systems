function [qnb, qnb0, wnck] = AlignCorse(wbib, fbsf, L, Ts)
% ���ƽ̨�ߵ����дֶ�׼
global glv
    len = length(wbib); t1 = fix(len*3/4);
    kxy = compasskxyz(len*Ts/2);
    qnb = [1;0;0;0]; qnb0 = qnb;
    wnie = glv.wie*[0; cos(L); sin(L)];
    wnck = zeros(len,3);
for n=1:1
    qnb = qnb0;
    vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % ״̬��ʼֵ
    for k=1:len
        qnb = qmul( qnb, rv2q((wbib(k,:)'-qmulv(qconj(qnb),wnie+wnc))*Ts) );
        fn = qmulv(qnb, fbsf(k,:)');
        [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos);   % �����ƽ
        wnck(k,:) = wnc';
    end
    % �ӿ��ƽ������м��㷽λ�ǣ��ο��ҵĽ���2011��10.5.2��
    cphi = 1+mean(wnck(t1:len,2))/wnie(2); sphi = -mean(wnck(t1:len,1))/wnie(2);
    n_phi = sqrt(cphi^2+sphi^2); cphi = cphi/n_phi; sphi = sphi/n_phi;
    Cnn = [cphi sphi 0; -sphi cphi 0; 0 0 1]; qnn = m2qnb(Cnn);
    qnb = qmul(qnn,qnb); % ���� 
    qnb0 = qnb;
    for k=len:-1:1    % ������̬����
        qnb0 = qmul( qnb0, rv2q(-(wbib(k,:)'-qmulv(qconj(qnb0),wnie))*Ts) );
    end
end