clc; close all; glvs

Ts = 0.1;  sTs = sqrt(Ts);  % ���沽��
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;10]*glv.deg,0,34*glv.deg, [1;1;3]*glv.min);
[wbib, fbsf, wnie] = ImuStatic(qnb0, pos0);
[eb, web, db, wdb] = drift_bias([1; 1; 1; 1]);
% eb = [0.01; 0.01; 0.01]*glv.dph; web =  [0.001; 0.001; 0.001]*glv.dph; % �������
% db =  [100; 100; 100]*glv.ug;  wdb =  [10; 10; 10]*glv.ug; % ���ٶȼ����
% �˲�������,�μ��������ߵ�ϵͳ��������ʼ��׼���ȷ��������桷
Qt = diag([web; 0;0])^2;
Rk = diag([wdb(1);wdb(2)])^2;
xk = zeros(5,1);
Pk = diag([[1;1;10]*glv.deg; [1;1]*glv.dph]/100)^2;
Phi = [ 0 wnie(3) -wnie(2)   0 0 
      -wnie(3) 0 0    -1 0 
      wnie(2) 0 0     0 -1 
      zeros(2,5) ];
% Phikk_1 = eye(5)+Phi*Ts;
Phikk_1 = expm(Phi*Ts);
Hk = [ 0 -glv.g0  0 0 0
      glv.g0 0   0 0 0 ];
 
t = 600;  % ��ʱ�䳤��
len = fix(t/Ts); res=zeros(len,3);
feedback=0.05;
s = 1.001;

for k=1:1:len
    [wm,vm] = ImuAddErr(wbib*Ts,fbsf*Ts,eb,web,db,wdb,Ts); wbe=wm/Ts; fbe=vm/Ts;
    qnb = qmul(qnb, rv2q( (wbe-qmulv(qconj(qnb),wnie))*Ts ));
    fn = qmulv(qnb, fbe);  
    zk = fn(1:2);
    [xk, Pk, Kk] = EKF(Phikk_1, Qt*Ts, xk, Pk, Hk, Rk, zk);
    res(k,:) = [xk(1:3) - qq2phi(qnb,qnb0)]';
end
time = [1:length(res)]*Ts;
figure;
subplot(3,1,1); plot(time, res(:,1)/glv.min); ylabel('\it\delta\phi_E\rm / arcmin'); grid on
subplot(3,1,2); plot(time, res(:,2)/glv.min); ylabel('\it\delta\phi_N\rm / arcmin'); grid on
subplot(3,1,3); plot(time, res(:,3)/glv.min); ylabel('\it\delta\phi_U\rm / arcmin'); grid on
xlabel('\itt \rm / s'); 
