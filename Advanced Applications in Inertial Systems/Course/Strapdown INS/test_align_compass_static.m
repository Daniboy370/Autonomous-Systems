clear all; close all; clc

glvs;
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;10]*glv.deg,0,34*glv.deg, [5;5;30]*glv.min);
[wbib, fbsf, wnie] = ImuStatic(qnb0, pos0);
[eb, web, db, wdb] = drift_bias([1; 1; 1; 1]);

[kxy, kz] = compasskxyz(20, 200);
vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % ״̬��ʼֵ

Ts = .1; % ���沽��
t = 600;  % ��ʱ�䳤��
len = fix(t/Ts); phik=zeros(len,3); 
for k=1:len
    [wm,vm] = ImuAddErr(wbib*Ts,fbsf*Ts,eb,web,db,wdb,Ts);
    we = wm/Ts; fe = vm/Ts;
    qnb = qmul( qnb, rv2q((we-qmulv(qconj(qnb),wnie+wnc))*Ts) );  % ������������wnc����̬����
    fn = qmulv(qnb, fe);  % �����任
    phik(k,:) = qq2phi(qnb, qnb0)';
    [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos, wnc, kz, wnie(2), k<(50/Ts)); % ǰ50sˮƽ��ƽ
    timedisp(k,Ts,100);
end
time = [1:length(phik)]*Ts;
figure
subplot(3,1,1), plot(time,phik(:,1)/glv.min), ylabel('\it\phi_E\rm / arcmin'); grid on
subplot(3,1,2), plot(time,phik(:,2)/glv.min), ylabel('\it\phi_N\rm / arcmin'); grid on
subplot(3,1,3), plot(time,phik(:,3)/glv.min), ylabel('\it\phi_U\rm / arcmin'); grid on
xlabel('\itt \rm / s'); 

    