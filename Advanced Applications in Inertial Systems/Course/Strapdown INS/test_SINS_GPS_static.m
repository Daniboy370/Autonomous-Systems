clear all
glvs
Ts=0.1;        %采样周期
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;0]*glv.deg,0,34*glv.deg, ...
                                        [0.5;-0.5;30]*glv.min,0.01,10);
dpos = [10/glv.Re; 10/glv.Re; 10];
[wbib, fbsf] = ImuStatic(qnb0, pos0);
[eb,web,db,wdb] = drift_bias([1;1;1;1]);

% 滤波器设置
Qt = diag([web; wdb; zeros(9,1)])^2;
Rk = diag(dpos)^2;
Pk = diag([[.1;.1;1]*glv.deg; [.1;.1;.1]; [10/glv.Re;10/glv.Re;10]; [.1;.1;.1]*glv.dph; [1;1;1]*glv.mg])^2;
Xk = zeros(15,1);
Hk = [zeros(3,6),eye(3),zeros(3,6)];
t = 900;  % 总时间长度
len = t/Ts; errphi=zeros(t,9); Xkk=zeros(t,15);
kk = 1;
for k=1:len
    [wm,vm] = ImuAddErr(wbib*Ts,fbsf*Ts,eb,web,db,wdb,Ts);
    [qnb,vn,pos]=sins(qnb,vn,pos,wm,vm,Ts);
    Ft = getf(qnb, vn, pos, vm./Ts); 
    [Fikk_1, Qk] = kfdis(Ft, Qt, Ts, 2); %离散化
    if mod(k,1/Ts)==0
        posGPS = pos0 + dpos.*randn(3,1); % 构造GPS位置
        Zk = pos - posGPS; % 位置误差观测量
        [Xk, Pk, Kk] = kalman(Fikk_1, Qk, Xk, Pk, Hk, Rk, Zk);   
        err(kk,:) = nav_err(qnb,vn,pos,qnb0,vn0,pos0)';
        Xkk(kk,:) = Xk';
        pos(3)=pos(3)-Xk(9,1); Xk(9,1) = 0; % 抑制高度
        kk = kk+1;
    else
        [Xk, Pk] = kalman(Fikk_1, Qk, Xk, Pk);  %无观测时只进行预测      
    end
    timedisp(k,Ts,100);
end
figure,
subplot(2,3,1),plot(err(:,1:3)/glv.min,'m'), 
subplot(2,3,2),plot(err(:,4:6),'m'), 
subplot(2,3,3),plot([err(:,7:8)*glv.Re,err(:,9)],'m');
subplot(2,3,1),hold on,plot(Xkk(:,1:3)/glv.min), 
xlabel('\itt\rm / s'); ylabel('\it\phi \rm / arcmin'); grid on
subplot(2,3,2),hold on,plot(Xkk(:,4:6)), 
xlabel('\itt\rm / s'); ylabel('\it\delta V \rm / m/s'); grid on
subplot(2,3,3),hold on,plot([Xkk(:,7:8)*glv.Re,Xkk(:,9)]), 
xlabel('\itt\rm / s'); ylabel('\it\delta P \rm / m'); grid on
subplot(2,3,4),plot(Xkk(:,10:12)/glv.dph), 
xlabel('\itt\rm / s'); ylabel('\it\epsilon \rm / \circ/h'); grid on
subplot(2,3,5),plot(Xkk(:,13:15)/glv.ug), 
xlabel('\itt\rm / s'); ylabel('\it\nabla \rm / ug'); grid on

