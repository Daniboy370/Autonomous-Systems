clear all; close all; clc
glvs;
w = 2*pi*10; %��Ƶ��
Ae = 30*glv.min; %�Ƿ�ֵ
Ap = 0.2; %�߷�ֵ
t = 0;
dEt_1 = [Ae*cos(w*t); 0; 0];  %������Ԫ�����Ե�����p333
dVt_1 = [0; -Ap*w*sin(w*t); 0];
ts = 0.01; n = 3; T = n*ts; %��������, ������, ��������
len = 6*(1/ts);  res = zeros(len/n,1); %����ʱ��
dVScull = 0;
t = ts; kk = 1;
for k=1:n:len
    for k1=1:n   %����n����
        dEt = [Ae*cos(w*t); 0; 0];
        dVt = [0; -Ap*w*sin(w*t); 0];
        wm(:,k1) = dEt-dEt_1; dEt_1=dEt;  %������
        vm(:,k1) = dVt-dVt_1; dVt_1=dVt;  %�ٶ�����
        t = t + ts;
    end
    cm = [0;0;0]; sm = [0;0;0];
    for k=1:n-1
        cm = cm + glv.cs(n-1,k)*wm(:,k); %׼��Բ׶����
    end
    for k=1:n-1
        sm = sm + glv.cs(n-1,k)*vm(:,k); %׼����������
    end
    dVScullm = cross(cm,vm(:,n))+cross(sm,wm(:,n)); %��������
    dVScull = dVScull + dVScullm(3);  %�ۼƻ������
    res(kk,:) = [dVScull]; kk = kk+1;
end
time = [1:length(res)]*T;
dvs_real = -1/2*Ae*Ap*w^2*(T-1/w*sin(w*T))*time/T; %���ۻ������
subplot(211), plot(time,res), ylabel('\it\DeltaVscul\rm  / m/s'); grid on
subplot(212), plot(time,[res-dvs_real']), ylabel('\it\DeltaVscul Err\rm  / m/s'); grid on
xlabel('\itt \rm / s'); 
return;