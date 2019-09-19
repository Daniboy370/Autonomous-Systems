clear all; close all; clc;
glvs
load trj100ms
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init(trj_0(1,1:3)',trj_0(1,4:6)',trj_0(1,7:9)',...
                                        [0.5;-0.5;30]*glv.min, 0.1, 10);
[eb,web,db,wdb] = drift_bias([1;1;1;1]);
% ״̬����
Xk = [nav_err(qnb,vn,pos,qnb0,vn0,pos0); eb; db]; I15 = eye(length(Xk));
len = length(trj_k); err = zeros(len,9); Xkk = zeros(len,15);
kk = 1; 
for k=1:len
    wm(:,1) = (trj_k(k,10:12)'+eb)*Ts;
    vm(:,1) = (trj_k(k,13:15)'+db)*Ts;
    [qnb,vn,pos]=sins(qnb,vn,pos,wm,vm,Ts);  
    Ft = getf(qnb, vn, pos, vm./Ts); 
    Xk = (I15+Ft*Ts)*Xk;
    err(k,:) = nav_err(qnb,vn,pos,trj_k(k,:))';
    Xkk(k,:) = Xk';
    timedisp(k,Ts,100);
end
time = [1:length(err)]*Ts;
figure,
subplot(3,1,1),plot(time,err(:,1:3)/glv.min-Xkk(:,1:3)/glv.min), ylabel('\it\phi_E_r_r\rm / arcmin'); grid on
subplot(3,1,2),plot(time,err(:,4:6)-Xkk(:,4:6)), ylabel('\it\delta V_E_r_r\rm / m/s');  grid on
subplot(3,1,3),plot(time,[err(:,7:8)*glv.Re,err(:,9)]-[Xkk(:,7:8)*glv.Re,Xkk(:,9)]); ylabel('\it\delta P_E_r_r\rm / m'); grid on
xlabel('\itt\rm / s'); 
