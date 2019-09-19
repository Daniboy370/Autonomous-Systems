clear
glvs;
Ts = .1;  % 步长
% 初始值
phi = [-5; 7; 80]*glv.deg;
[NA,vn,pos,qnb0,vn0,pos0] = nav_init([10;0;-80]*glv.deg,0,34*glv.deg, phi,0.1,10);
qpb = qaddafa(qnb0,phi);  % 姿态误差需额外处理
[wbib, fbsf, wnie, gn] = ImuStatic(qnb0, pos0);
[eb,web,db,wdb] = drift_bias([1;1;1;1]);
% 滤波器参数
Pw = diag([[.1;.1;.1]*glv.dph; [.1;.1;.1]*glv.mg])^2;
Pv = diag([0.1;0.1;0.1])^2;
Pk = diag([.5*pi;.5*pi;1*pi; 10;10;10])^2;
H = [zeros(3,3),eye(3)];
Xk = zeros(6,1);
t = 600; % 总仿真时间
len = fix(t/Ts); err=zeros(len,6); xkk=err;
for k=1:len
    % 阻尼sins解算
    [wm,vm] = ImuAddErr(wbib*Ts,fbsf*Ts,eb,web,db,wdb,Ts); wbe=wm/Ts; fbe=vm/Ts;
    vn = vn + qmulv(qpb,fbe*Ts) + gn*Ts;
    qpb = qmul(qpb, rv2q(wbe*Ts - qmulv(qconj(qpb),wnie*Ts)));
    err(k,:) = [qq2afa(qpb,qnb0)', vn']; % 注意区别于线性模型姿态误差角的提取
    % ukf滤波
    zk = vn;
    tVar = [wnie;qmulv(qpb,fbe);Ts];
    [Xk, Pk] = ukf(Xk, Pk, Pw, Pv, zk, @large_phi_model, tVar, H);
    Pk = 1.01*Pk;
    xkk(k,:) = Xk';
    timedisp(k,Ts,100);
end
time = [1:length(err)]*Ts;
figure
subplot(3,1,1), plot(time,[err(:,1),xkk(:,1)]/glv.deg), ylabel('\it\phi_x\rm / \circ'); grid on
subplot(3,1,2), plot(time,[err(:,2),xkk(:,2)]/glv.deg), ylabel('\it\phi_y\rm / \circ'); grid on
subplot(3,1,3), plot(time,[err(:,3),xkk(:,3)]/glv.deg), ylabel('\it\phi_z\rm / \circ'); grid on
xlabel('\itt \rm / s');
figure
subplot(3,1,1), plot(time,[err(:,4),xkk(:,4)]), ylabel('\itV_x\rm / m/s'); grid on
subplot(3,1,2), plot(time,[err(:,5),xkk(:,5)]), ylabel('\itV_y\rm / m/s'); grid on
subplot(3,1,3), plot(time,[err(:,6),xkk(:,6)]), ylabel('\itV_z\rm / m/s'); grid on
xlabel('\itt \rm / s');
