% ���ٶ���Ϊ�۲�����Kalman��ʼ��׼
% ״̬ x; [phiE,phiN,phiU, deltavE,deltavN, enE,enN,enU, dnE,dnN]
% ���� z: [deltavE,deltavN];

clear; glvs
imu = load('lgimu.dat');  % Լ��Сʱ���ݣ���������8ms����6������:ǰ3Ϊ����������3Ϊ�ٶ�����
imu = [imu(:,1:3)*0.932*glv.sec, imu(:,4:6)*500*glv.ug];
Ts = 0.008;   % ����
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0.9; 0.2; -90.6]*glv.deg,0,34.246*glv.deg,...
                                        [1;1;10]*glv.min, 0.1, 10);
[wnie, wnen, gn, retp] = earth(pos);

% �˲�������
[eb, web, db, wdb] = drift_bias([0; 1; 0; 1]);
Qt = diag([web; wdb(1:2); 0;0;0; 0;0])^2;
Rk = diag([0.1;0.1])^2;
xk = zeros(10,1);
Pk = diag([[1;1;10]*glv.deg; [1;1]; [1;1;1]*0.01*glv.dph; [100;100]*glv.ug])^2;
Ft = zeros(10,10); Ft(1:3,1:3) = askew(-wnie);
Hk = zeros(2,10); Hk(1,4) = 1; Hk(2,5) = 1;
 
t = 300;  % ��ʱ�䳤��
len = fix(t/Ts); res=zeros(t,10); kk = 1;

for k=1:1:len
    wm = imu(k,1:3)';    vm = imu(k,4:6)';
    [phim, dvm] = cnscl(wm, vm);
    vn = vn + qmulv(qnb,dvm) + gn*Ts; % �ٶȸ���
    qnb = qmul(qnb, rv2q( phim-qmulv(qconj(qnb),wnie)*Ts ));  % ��̬����
    Cnb = q2cnb(qnb); fn = Cnb*(vm/Ts);
    Ft(4,2) = -fn(3); Ft(4,3) = fn(2); Ft(5,1) = fn(3); Ft(5,3) = -fn(1);
    Ft(1:3,6:8) = -Cnb; Ft(4:5,9:10) = Cnb(1:2,1:2);
    if mod(k,1/Ts)==0
        zk = vn(1:2);  % ��ˮƽ�ٶ�Ϊ�۲���
        [xk, Pk, Kk] = kalman(eye(10)+Ft*Ts, Qt*Ts, xk, Pk, Hk, Rk, zk);
        res(kk,:) = xk';
        kk = kk+1;
    else
        [xk, Pk] = kalman(eye(10)+Ft*Ts, Qt*Ts, xk, Pk);  %�޹۲�ʱֻ����Ԥ��      
    end
    timedisp(k, Ts, 100);
end
time = [1:length(res)];
figure;
subplot(2,2,1); plot(time,res(:,1:3)/glv.min); ylabel('\it\phi\rm / arcmin'); grid on
subplot(2,2,2); plot(time,res(:,4:5)); ylabel('\it\delta v_E ,\delta v_N\rm / m/s'); grid on
subplot(2,2,3); plot(time,res(:,6:8)/glv.dph); ylabel('\it\epsilon\rm  / \circ/h'); grid on
xlabel('\itt \rm / s'); 
subplot(2,2,4); plot(time,res(:,9:10)/glv.dph); ylabel('\it\nabla\rm / ug'); grid on
xlabel('\itt \rm / s'); 
