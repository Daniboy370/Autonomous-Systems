clear all; close all; clc
glvs
load trj100ms.mat
[eb,web,db,wdb] = drift_bias([1;0;1;0]);
[wm,vm] = ImuAddErr(trj_k(:,10:12)*Ts,trj_k(:,13:15)*Ts,eb,web,db,wdb,Ts);
n = 2;    % ������
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init(trj_0(1,1:3)',trj_0(1,4:6)',trj_0(1,7:9)',...
    [5;0.5;30]*glv.min, 0.1, 0);
dKD = 0.05;
kk = 1;
len = fix(length(wm)/n-1); err=zeros(len,9);
for k=1:n:len*n
    k1 = k+n-1;
    wme = wm(k:k1,:)';  % �������������
    vn0=trj_k(k1,4:6)';
    dSb = [0; norm(vn0)*n*Ts;0]*(1+dKD);
    [qnb, pos] = DR(qnb,pos,wme,dSb,Ts);
    err(kk, :) = nav_err(qnb,vn,pos,trj_k(k,:))';
    posk(kk, :) = pos';
    kk = kk+1;
end
time = [1:length(err)]*Ts*n;
figure;
subplot(2,1,1),plot(time,err(:,1:3)/glv.min), ylabel('\it\phi\rm / arcmin'); grid on
subplot(2,1,2),plot(time,[err(:,7:8)*glv.Re,err(:,9)]), ylabel('\it\delta P\rm / m'); grid on
xlabel('\itt\rm / s');

figure;
plot([trj_k(:,8)-trj_k(1,8)]*glv.Re*cos(trj_k(1,7)), [trj_k(:,7)-trj_k(1,7)]*glv.Re, ...
    [posk(:,2)-trj_k(1,8)]*glv.Re*cos(posk(1,1)), [posk(:,1)-trj_k(1,7)]*glv.Re); grid on
xlabel('\lambda / m'), ylabel('L / m');