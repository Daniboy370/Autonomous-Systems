function [qnb, qnb0, wnck] = AlignCorse(wbib, fbsf, L, Ts)
% 借鉴平台惯导进行粗对准
global glv
    len = length(wbib); t1 = fix(len*3/4);
    kxy = compasskxyz(len*Ts/2);
    qnb = [1;0;0;0]; qnb0 = qnb;
    wnie = glv.wie*[0; cos(L); sin(L)];
    wnck = zeros(len,3);
for n=1:1
    qnb = qnb0;
    vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % 状态初始值
    for k=1:len
        qnb = qmul( qnb, rv2q((wbib(k,:)'-qmulv(qconj(qnb),wnie+wnc))*Ts) );
        fn = qmulv(qnb, fbsf(k,:)');
        [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos);   % 仅需调平
        wnck(k,:) = wnc';
    end
    % 从控制角速率中计算方位角，参考我的讲义2011版10.5.2节
    cphi = 1+mean(wnck(t1:len,2))/wnie(2); sphi = -mean(wnck(t1:len,1))/wnie(2);
    n_phi = sqrt(cphi^2+sphi^2); cphi = cphi/n_phi; sphi = sphi/n_phi;
    Cnn = [cphi sphi 0; -sphi cphi 0; 0 0 1]; qnn = m2qnb(Cnn);
    qnb = qmul(qnn,qnb); % 修正 
    qnb0 = qnb;
    for k=len:-1:1    % 逆向姿态更新
        qnb0 = qmul( qnb0, rv2q(-(wbib(k,:)'-qmulv(qconj(qnb0),wnie))*Ts) );
    end
end