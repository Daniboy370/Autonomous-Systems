% �������޾���׼
clear all; close all; clc;
glvs;
load trj100ms.mat
[qnb, vn, pos, qnb0, vn0, pos0] = nav_init(trj_0(1,1:3)',trj_0(1,4:6)',trj_0(1,7:9)',...
                                        [-5;5;30]*glv.min, 0.1, 10);
[eb, web, db, wdb] = drift_bias([1; 1; 1; 1]);
[kxy, kz] = compasskxyz(100, 600);
vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % ״̬��ʼֵ
len = length(trj_k); phik=zeros(len,3);
for k=1:len
    [wm,vm] = ImuAddErr(trj_k(k,10:12)'*Ts,trj_k(k,13:15)'*Ts,eb,web,db,wdb,Ts);
    wbib = wm/Ts; fbsf = vm/Ts;
    vnr = trj_k(k,4:6)';     % �ο��ٶ�
    [wnie, wnen, gn, retp] = earth(pos,vnr); wnin = wnie + wnen;
    qnb = qmul( qnb, rv2q((wbib-qmulv(qconj(qnb),wnin+wnc))*Ts) );  % ������������wnc����̬����
    fn = qmulv(qnb, fbsf);  % �����任
    phik(k,:) = qq2phi(qnb, a2qnb(trj_k(k,1:3)))';
    [vn, dpos, wnc] = compassCmd(fn, vn, vnr(1:2), kxy, Ts, dpos, wnc, kz, wnie(2), k<(100/Ts)); % ǰ50sˮƽ��ƽ
    pos = pos + Ts*[vn(2)/retp.rmh;vn(1)/(retp.rnh*retp.cl);0];
    timedisp(k, Ts, 100);
end
time = [1:length(phik)]*Ts;
figure
subplot(3,1,1); plot(time, phik(:,1)/glv.min), 
ylabel('\it\phi_E\rm / arcmin'); grid on

subplot(3,1,2), plot(time,phik(:,2)/glv.min), 
ylabel('\it\phi_N\rm / arcmin'); grid on

subplot(3,1,3), plot(time,phik(:,3)/glv.min), ylabel('\it\phi_U\rm / arcmin'); grid on
xlabel('\itt \rm / s');

