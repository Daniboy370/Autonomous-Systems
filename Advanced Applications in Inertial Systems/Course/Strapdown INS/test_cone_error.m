clear all;
addpath(pwd, 'basefun');
glvs;
afa = 1.0*glv.deg;      %��׶��
f = 1;  w = 2*pi*f;     %׶�˶�Ƶ��
th = 0.01;  n = 5;  nth = n*th;     %����ʱ��, ������, ��������
time = 60;  %����ʱ�䳤��
len = fix(time/nth);  res = zeros(len,3);  %���沽��
t = 0;          %��ʼ��̬��Ԫ��
qnb_calcu = [cos(afa/2); sin(afa/2)*cos(w*t); sin(afa/2)*sin(w*t); 0];
for k=1:len
    for k1=1:n   %����n����
        wm(:,k1) = [-2*sin(afa)*sin(w*th/2)*sin(w*(t+th/2));
            2*sin(afa)*sin(w*th/2)*cos(w*(t+th/2));
            -2*w*th*(sin(afa/2))^2 ];  %������
        t = t + th;
    end
    qnb_real = [cos(afa/2); sin(afa/2)*cos(w*t); sin(afa/2)*sin(w*t); 0]'; % ��̬��Ԫ����ֵ
    phi = cnscl(wm);         %Բ׶����
    qnb_calcu = qmul(qnb_calcu,rv2q(phi));    %��̬����
    res(k,:) = qq2phi(qnb_calcu,qnb_real)';  %����̬���
end
time = [1:length(res)]*nth;
figure
subplot(3,1,1), plot(time,res(:,1)/glv.sec), ylabel('\it\phi_x\rm / arcsec'); grid on 
subplot(3,1,2), plot(time,res(:,2)/glv.sec), ylabel('\it\phi_y\rm / arcsec'); grid on
subplot(3,1,3), plot(time,res(:,3)/glv.sec), ylabel('\it\phi_z\rm / arcsec'); grid on
xlabel('\itt \rm / s'); 
% ����Բ׶���
k2 = 1;
for k1=1:n+1
    k2 = k2*(2*k1-1);
end
epsilon = afa^2*(2*pi*f*th)^(2*n+1) * n*factorial(n) / (2^(n+1)*k2);
subplot(3,1,3), hold on, plot([0,time(end)],[0,epsilon*length(time)]/glv.sec,'r--')
