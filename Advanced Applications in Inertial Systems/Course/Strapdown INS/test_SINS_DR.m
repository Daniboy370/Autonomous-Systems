clear all; close all; clc;
glvs
load data\trj100ms
randn('seed', 170);
[eb,web,db,wdb] = drift_bias([1;1;1;1]);
[wm,vm] = ImuAddErr(trj_k(:,10:12)*Ts,trj_k(:,13:15)*Ts,eb,web,db,wdb,Ts);
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init(trj_0(1,1:3)',trj_0(1,4:6)',trj_0(1,7:9)',...
                                        [0.5;-0.5;30]*glv.min, 0.1, 10);
dpos = [10/glv.Re; 10/glv.Re; 10];
posDR = pos;
dKD = 0.01; % ��̼ƿ̶�ϵ�����
% �˲�������
Qt = diag([web; wdb; zeros(13,1)])^2;
Rk = diag(dpos)^2;
Pk = diag([[.1;.1;1]*glv.deg; [.1;.1;.1]; [10/glv.Re;10/glv.Re;10]; [.1;.1;.1]*glv.dph; [1;1;1]*glv.mg; ...
    [10/glv.Re;10/glv.Re;10]; 0.01])^2;
Xk = zeros(19,1);
Hk = [zeros(3,6),eye(3),zeros(3,6),-eye(3),zeros(3,1)];
len = length(trj_k);
len1 = fix(len*Ts);
err = zeros(len1,9); errposDR = zeros(len1,3); Xkk = zeros(len1,length(Xk));
kk = 1; 
for k=1:len
    [qnb,vn,pos]=sins(qnb,vn,pos,wm(k,:)',vm(k,:)',Ts);
    vnr=trj_k(k,4:6)'; dSb = [0; norm(vnr)*Ts*(1+dKD); 0];
    [NA, posDR] = DR(qnb, posDR, wm(k,:)', dSb, Ts);
    Ft = getf_DR(qnb, vn, pos, vm(k,:)'./Ts, 15);
    [Fikk_1, Qk] = kfdis(Ft, Qt, Ts, 2); %��ɢ��  Fikk_1 = eye(15)+Ft*Ts; Qk = Qt*Ts;
    if mod(k,1/Ts)==0
        Zk = pos - posDR;
        [Xk, Pk, Kk] = KF(Fikk_1, Qk, Xk, Pk, Hk, Rk, Zk);
        err(kk,:) = nav_err(qnb,vn,pos,trj_k(k,:))';
        errposDR(kk,:) = posDR'-trj_k(k,7:9);
        Xkk(kk,:) = Xk';
        kk = kk+1;
    else
        [Xk, Pk] = KF(Fikk_1, Qk, Xk, Pk);  %�޹۲�ʱֻ����Ԥ��      
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
subplot(2,3,6),plot(Xkk(:,19)), 
xlabel('\itt\rm / s'); ylabel('\it\delta K_D'); grid on
figure,
plot([err(:,7:8)*glv.Re,err(:,9)]-[Xkk(:,7:8)*glv.Re,Xkk(:,9)],'m');
hold on, plot([errposDR(:,1:2)*glv.Re,errposDR(:,3)]);
xlabel('\itt\rm / s'); ylabel('\it\delta P \rm / m'); grid on
