close all; clc; clear all; glvs

Ts = 0.1;
att = [0; 0; 0]*glv.deg;
vn = [0; 0; 0];
pos =[34.246048*glv.deg; 108.909664*glv.deg; 380];
v1 = 10; w1 = .9*glv.deg; a1 = w1*v1;
v2 = 10; w2 = 1.0*glv.deg; a2 = w2*v2;
para = [   %��������: ����ʱ��, wtx,wty,wtz, atx,aty,atz    
    100, 0, 0, 0, 0, 0, 0       %��ֹ(����)
    10, 0, 0, 0, 0, 1, 0        %����
    100, 0, 0, 0, 0, 0, 0
    100, 0, 0, w1, -a1, 0, 0    %��ת��
    100, 0, 0, 0, 0, 0, 0
    100, 0, 0, -w1, a1, 0, 0    %��ת��
    100, 0, 0, 0, 0, 0, 0
    10, w2, 0, 0, 0, 0, a2      %̧ͷ
    100, 0, 0, 0, 0, 0, 0
    10, -w2, 0, 0, 0, 0, -a2    %��ͷ
    100, 0, 0, 0, 0, 0, 0
    10, 0, 0, 0, 0, -1, 0       %����
    60, 0, 0, 0, 0, 0, 0
];
% para = repmat(para, n, 1); %�޸�n�����������ظ��켣

len = sum(para(:,1))/Ts;
trj_0 = [att;vn;pos;zeros(6,1)]';
trj_k = zeros(len,15);      %��������ռ�
kk = 1;

for k=1:size(para,1)
    lenk = para(k,1)/Ts;
    wt = para(k,2:4)'; at = para(k,5:7)';
    for j=1:lenk
        [att, vn, pos, wbib, fbsf] = trj(att, vn, pos, wt, at, Ts);
        trj_k(kk,:) = [att; vn; pos; wbib; fbsf]';
        kk = kk+1;
        if mod(kk,100/Ts)==0    %������ʾ
            disp(kk/(1/Ts))
        end
    end
end

time = [1:length(trj_k)]'*Ts;
figure
subplot(3,3,1),plot(time,trj_k(:,1)/glv.deg), ylabel('\it\theta\rm / \circ'); grid on
subplot(3,3,4),plot(time,trj_k(:,2)/glv.deg), ylabel('\it\gamma\rm / \circ'); grid on
subplot(3,3,7),plot(time,trj_k(:,3)/glv.deg), ylabel('\it\psi\rm / \circ'); grid on
xlabel('\itt\rm / s');
subplot(3,3,2),plot(time,trj_k(:,4)), ylabel('\itV_E\rm / m/s'); grid on
subplot(3,3,5),plot(time,trj_k(:,5)), ylabel('\itV_N\rm / m/s'); grid on
subplot(3,3,8),plot(time,trj_k(:,6)), ylabel('\itV_U\rm / m/s'); grid on
xlabel('\itt\rm / s');
subplot(3,3,3),plot(time,trj_k(:,7)/glv.deg), ylabel('\itL\rm / \circ'); grid on
subplot(3,3,6),plot(time,trj_k(:,8)/glv.deg), ylabel('\it\lambda\rm / \circ'); grid on
subplot(3,3,9),plot(time,trj_k(:,9)), ylabel('\ith\rm / m'); grid on
xlabel('\itt\rm / s');
figure
subplot(3,2,1),plot(time,trj_k(:,10)/glv.deg), ylabel('\it\omega_x\rm / \circ/s'); grid on
subplot(3,2,3),plot(time,trj_k(:,11)/glv.deg), ylabel('\it\omega_y\rm / \circ/s'); grid on
subplot(3,2,5),plot(time,trj_k(:,12)/glv.deg), ylabel('\it\omega_z\rm / \circ/s'); grid on
xlabel('\itt\rm / s');
subplot(3,2,2),plot(time,trj_k(:,13)), ylabel('\itf_x\rm / m/s^2'); grid on
subplot(3,2,4),plot(time,trj_k(:,14)), ylabel('\itf_y\rm / m/s^2'); grid on
subplot(3,2,6),plot(time,trj_k(:,15)/glv.g0), ylabel('\itf_z\rm / g'); grid on
xlabel('\itt\rm / s');
