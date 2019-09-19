clear all
glvs;
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;30]*glv.deg,0,34*glv.deg,[-5;5;30]*glv.min);
[wbib, fbsf, wnie] = ImuStatic(qnb0, pos0);
[eb, web, db, wdb] = drift_bias([1; 1; 1; 1]);

[kxy, kz] = compasskxyz(20, 200);
vn = [0;0]; dpos=[0;0]; wnc = zeros(3,1); % 状态初始值

Ts = .1; sTs = sqrt(Ts); % 仿真步长
t = 100;  % 总时间长度
len = fix(t/Ts);
wm = repmat(wbib'*Ts,len,1); vm = repmat(fbsf'*Ts,len,1);
[wm,vm] = ImuAddErr(wm,vm,eb,web,db,wdb,Ts);
kk = 1; k = 1;
N = 9; % 对准次数
len1 = len*N; phik = zeros(len1,3);
reverse = 1;
for n = 1:len1
    wbib = wm(k,:)'/Ts;
    fbsf = vm(k,:)'/Ts;
    qnb = qmul( qnb, rv2q((reverse*wbib-qmulv(qconj(qnb),reverse*wnie+wnc))*Ts) );  % 带反馈控制项wnc的姿态更新
    fn = qmulv(qnb, fbsf);  % 比力变换
    phik(n,:) = qq2phi(qnb, qnb0)';
    [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos, wnc, kz, wnie(2), kk==1&&k<(50/Ts));
    %%%%%%%%%%%%%%%%%%%%%%  正---逆方向控制
    if reverse==1  % 正向
        k = k + 1;
        if k == len+1
            k = len;    kk = kk + 1;
            reverse = -1; 
            disp(kk),
        end
    else    % 逆向
        k = k - 1;
        if k == 0
            k = 1;  kk = kk + 1;
            reverse = 1; 
        end
    end
end
time = [1:length(phik)]*Ts;
figure
subplot(3,1,1), plot(time,phik(:,1)/glv.min), ylabel('\it\phi_E\rm / arcmin'); grid on
subplot(3,1,2), plot(time,phik(:,2)/glv.min), ylabel('\it\phi_N\rm / arcmin'); grid on
subplot(3,1,3), plot(time,phik(:,3)/glv.min), ylabel('\it\phi_U\rm / arcmin'); grid on
subplot(3,1,1), hold on, plot(time(len:len:end),phik(len:len:end,1)/glv.min,'*r'),
subplot(3,1,2), hold on, plot(time(len:len:end),phik(len:len:end,2)/glv.min,'*r'),
subplot(3,1,3), hold on, plot(time(len:len:end),phik(len:len:end,3)/glv.min,'*r'),
xlabel('\itt \rm / s'); 

    