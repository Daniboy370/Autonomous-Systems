clear all; close all; clc;
glvs;
imu = load('lgimu.dat');                     % Load IMU data
imu = [imu(:,1:3)*0.932*glv.sec, imu(:,4:6)*500*glv.ug];
Ts = 0.008;   % ����
[kxy, kz] = compasskxyz(20, 200);
vn = [0;0]; dpos = [0;0];  wnc = zeros(3,1); % ״̬��ʼֵ
pos = [34.246048*glv.deg; 108.909663*glv.deg; 380];  % �������Զ���ѧԺ���Լ���ʵ����λ��
[wnie, wnen, gn] = earth(pos);
% qnb = a2qnb([0.8; 0.3; -90.6]*glv.deg); % ��̬����ֵ
[att, pi0k, pib0k] = align_i0(imu(1:30*125,1:3), imu(1:30*125,4:6), pos, Ts);
qnb = a2qnb(att(end,:)');
q2att(qnb)/glv.deg
t = 600;  % ��ʱ�䳤��
len = fix(t/Ts); attk=zeros(len,3);
for k=1:len
    wbib = imu(k,1:3)'/Ts;
    fbsf = imu(k,4:6)'/Ts;
    qnb = qmul( qnb, rv2q((wbib-qmulv(qconj(qnb),wnie+wnc))*Ts) );  % ������������wnc����̬����
    fn = qmulv(qnb, fbsf);  % �����任
    attk(k,:) = q2att(qnb)';
    [vn, dpos, wnc] = compassCmd(fn, vn, [0;0], kxy, Ts, dpos, wnc, kz, wnie(2), k<(50/Ts)); 
    timedisp(k, Ts, 100);
end
time = [1:length(attk)]*Ts;
figure
subplot(3,1,1), plot(time,attk(:,1)/glv.deg), ylabel('\it\theta\rm / \circ'); grid on
subplot(3,1,2), plot(time,attk(:,2)/glv.deg), ylabel('\it\gamma\rm / \circ'); grid on
subplot(3,1,3), plot(time,attk(:,3)/glv.deg), ylabel('\it\psi\rm / \circ'); grid on
xlabel('\itt \rm / s'); 

    