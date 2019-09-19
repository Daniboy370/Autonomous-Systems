% ������ʶ��ʼ����׼(��ʼ��̬���ϴ�ʱ��׼���Ȳ���!)
clc; close all; clear; 
glvs;
imu = load('lgimu.dat');
imu = [imu(:,1:3)*0.932*glv.sec, imu(:,4:6)*500*glv.ug];
Ts = 0.008;   % ����
pos = [34.246048*glv.deg; 108.909663*glv.deg; 380];  % �������Զ���ѧԺ���Լ���ʵ����λ��
[wnie, wnen, gn, retp] = earth(pos);
qnb = a2qnb([0.897, 0.165, -90.6]*glv.deg); % ��̬����ֵ
% att = align_i0(imu(1:30*125,1:3), imu(1:30*125,4:6), pos, Ts); att(end,:)/glv.deg
% qnb = a2qnb(att(end,:)');
t = 600;  % ��ʱ�䳤��
len = fix(t/Ts); attk = zeros(len,3); 
H0 = [Ts,Ts^2,Ts^3; (2*Ts),(2*Ts)^2,(2*Ts)^3; (3*Ts),(3*Ts)^2,(3*Ts)^3]; 
Pm = (H0'*H0)^-1; 
aEm = zeros(3,1); aNm = aEm; vn = zeros(3,1);
for k=1:len
    vn = vn + qmulv(rv2q(-wnie*Ts/2), qmulv(qnb,imu(k,4:6)')) + gn*Ts;
    qnb = qmul( qnb, rv2q((imu(k,1:3)'-qmulv(qconj(qnb),wnie*Ts))) );
    kTs = k*Ts;
    Hm = [kTs, kTs^2, kTs^3];
    [aEm, Pm, Km] = RLS(aEm, Pm, Hm, 1, vn(1));    aNm = aNm + Km*(vn(2)-Hm*aNm);
    [phi, phi0] = prls([aEm;aNm], pos(1), kTs);
    attk(k,:) = q2att(qdelphi(qnb,phi))';
    timedisp(k,Ts,100);
end
time = [1:length(attk)]*Ts;
figure
subplot(3,1,1), plot(time,attk(:,1)/glv.deg), ylabel('\it\theta\rm / \circ'); grid on
subplot(3,1,2), plot(time,attk(:,2)/glv.deg), ylabel('\it\gamma\rm / \circ'); grid on
subplot(3,1,3), plot(time,attk(:,3)/glv.deg), ylabel('\it\psi\rm / \circ'); grid on
xlabel('\itt \rm / s'); 
    