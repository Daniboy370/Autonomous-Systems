close all; clc; clear all; glvs
dt = .1;

[qnb, vn, pos, qnb0, vn0, pos0] = nav_init([0;0;10]*glv.deg,0,34*glv.deg, [1;1;3*60]*glv.min);
[wbib, fbsf, wnie, gn] = ImuStatic(qnb0, pos0);
[eb, web, db, wdb] = drift_bias([1; 1; 1; 1]);
    
Qt = diag([web; wdb(1:2); 0;0;0;0;0])^2;
Rk = diag([0.1;0.1])^2;
xk = zeros(10,1);
Pk = diag([[1;1;100]*glv.deg; [1;1]; [1;1;1]*glv.dph; [1;1]*glv.mg])^2;
Hk = zeros(2,10); Hk(1,4) = 1; Hk(2,5) = 1;     % The desired measured states

wN = wnie(2); wU = wnie(3); g = -gn(3);
F = zeros(10,10);
F(1,2) = wU; F(1,3) = -wN; F(1,6) = -1;
F(2,1) = -wU; F(2,3) = 0; F(2,7) = -1;
F(3,1) = wN; F(3,8) = -1;
F(4,1) = 0; F(4,2) = -g; F(4,3) = 0;  F(4,9) = 1; F(4,10) = 0;
F(5,1) = g; F(5,2) = 0; F(5,3) = 0;   F(5,9) = 0; F(5,10) = 1;
Phi = eye(10)+F*dt;

t = 600; 
len = fix(t/dt); Res_KF = zeros(len,10);
Res_EKF = Res_KF;
exk = xk; ePk = Pk; 
vn = zeros(3, 1);

for k=1:1:len
    [wm, vm] = ImuAddErr(wbib*dt,fbsf*dt, eb, web, db, wdb, dt); 
    wbe = wm/dt; fbe = vm/dt;
    qnb = qmul(qnb, rv2q( (wbe-qmulv(qconj(qnb),wnie))*dt )); 
    fn = qmulv(qnb, fbe);
    vn = vn + (fn+gn)*dt; v_n(:, k) = vn;
    Ft = f_t(exk, wnie, fn);
    Phi = expm(F*dt);
    % KF
%     [xk, Pk, Kk] = KF(Phi, Qt*dt, xk, Pk, Hk, Rk, vn(1:2));
%     Res_KF(k,:) = [xk(1:3)-qq2phi(qnb,qnb0); xk(4:end)]'; 
    % ---------------- EKF ---------------- %
    fXk_1 = F_mat(exk, wnie, fn, dt);
    [exk, ePk, Kk] = EKF(Phi, Qt*dt, fXk_1, ePk, Hk, Rk, vn(1:2)-Hk*fXk_1);
    Res_EKF(k,:) = [exk(1:3)-qq2afa(qnb,qnb0); exk(4:end)]'; 
    timedisp(k, dt, 100);
end
time = [1:len]*dt;
% figure;
% subplot(3,1,1); plot(time,[Res_KF(:,1),Res_EKF(:,1)]/glv.min); ylabel('\it\delta p_E\rm / arcmin'); grid on
% subplot(3,1,2); plot(time,[Res_KF(:,2),Res_EKF(:,2)]/glv.min); ylabel('\it\delta p_N\rm / arcmin'); grid on
% subplot(3,1,3); plot(time,[Res_KF(:,3),Res_EKF(:,3)]/glv.min); ylabel('\it\delta p_U\rm / arcmin'); grid on
% xlabel('\itt \rm / s');
% 
% figure;
% subplot(3,1,1); plot(time,[Res_KF(:,4),Res_EKF(:,4)]/glv.min); ylabel('\it\delta v_E\rm / arcmin'); grid on
% subplot(3,1,2); plot(time,[Res_KF(:,5),Res_EKF(:,5)]/glv.min); ylabel('\it\delta v_N\rm / arcmin'); grid on
% subplot(3,1,3); plot(time,[Res_KF(:,6),Res_EKF(:,6)]/glv.min); ylabel('\it\delta v_U\rm / arcmin'); grid on
% xlabel('\itt \rm / s');

%%
figure; hold on; grid on;
plot3( v_n(1, :), v_n(2, :), v_n(3, :) );
% plot3( Exk(4, :), Exk(5, :), Exk(6, :) );



%%
figure;
subplot(3,1,1); plot(time,[Res_KF(:,7),Res_EKF(:,7)]/glv.min); ylabel('\it\delta \epsilon_E\rm / arcmin'); grid on
subplot(3,1,2); plot(time,[Res_KF(:,8),Res_EKF(:,8)]/glv.min); ylabel('\it\delta \epsilon_N\rm / arcmin'); grid on
subplot(3,1,3); plot(time,[Res_KF(:,9),Res_EKF(:,9)]/glv.min); ylabel('\it\delta \epsilon_U\rm / arcmin'); grid on
xlabel('\itt \rm / s');


function F = f_t(Xk_1, wnie, fn)
ax = Xk_1(1); ay = Xk_1(2); az = Xk_1(3); Dx = Xk_1(9); Dy = Xk_1(10);
caz = cos(az); saz = sin(az);
wN = wnie(2); wU = wnie(3);
fx = fn(1); fy = fn(2); fz = fn(3);
F = zeros(10,10);
F(1,2) = wU; F(1,3) = -caz*wN; F(1,6) = -1;
F(2,1) = -wU; F(2,3) = saz*wN; F(2,7) = -1;
F(3,1) = caz*wN; F(3,3) = -ax*saz*wN; F(3,8) = -1;
F(4,1) = -saz*fz; F(4,2) = -caz*fz; F(4,3) = saz*fx+caz*fy-(-ay*saz+ax*caz)*fz-saz*Dx+caz*Dy;
F(4,9) = caz; F(4,10) = saz;
F(5,1) = caz*fz; F(5,2) = -saz*fz; F(5,3) = -caz*fx+saz*fy-(ay*caz+ax*saz)*fz-caz*Dx-saz*Dy;
F(5,9) = -saz; F(5,10) = caz;
end

function fX = F_mat(Xk_1, wnie, fn, Ts)
ax = Xk_1(1); ay = Xk_1(2); az = Xk_1(3); dvx = Xk_1(4); dvy = Xk_1(5);
ex = Xk_1(6); ey = Xk_1(7); ez = Xk_1(8); Dx = Xk_1(9); Dy = Xk_1(10);
caz = cos(az); saz = sin(az);
wN = wnie(2); wU = wnie(3);
fx = fn(1); fy = fn(2); fz = fn(3);
fX = Xk_1;
fX(1) = ax + (-saz*wN+ay*wU-ex)*Ts;
fX(2) = ay + ((1-caz)*wN-ax*wU-ey)*Ts;
fX(3) = az + (ax*caz*wN-ez)*Ts;
fX(4) = dvx + ((1-caz)*fx+saz*fy-(ay*caz+ax*saz)*fz+caz*Dx+saz*Dy)*Ts;
fX(5) = dvy + (-saz*fx+(1-caz)*fy-(ay*saz-ax*caz)*fz-saz*Dx+caz*Dy)*Ts;
end