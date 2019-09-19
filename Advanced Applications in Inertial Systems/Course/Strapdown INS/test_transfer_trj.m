clear all
glvs
Ts = 0.01;       %解算步长(周期)
%轨迹参数设置
att = [0; 0; 0]*glv.deg;
vn = [0; 180; 0];
pos =[34.246048*glv.deg; 108.909664*glv.deg; 380];
roll_f = 0.5;
roll = 20*glv.deg * [cos(2*pi*roll_f*[0:Ts:0.5/roll_f]')-1; 
    -2*cos(2*pi*roll_f*[0:Ts:0.5/roll_f]'); 
    cos(2*pi*roll_f*[0:Ts:0.5/roll_f]')+1] * 0.5;  %摇翼横滚角规律
wy = diff(roll)/Ts;
wt = [zeros(10/Ts,3);       %匀速
    zeros(length(wy),1), wy, zeros(length(wy),1); %摇翼
    zeros(10/Ts,3) ];       %匀速
at = zeros(size(wt));

len = length(wt);
trj_0 = [att;vn;pos;zeros(6,1)]';
trj_k = zeros(len,15);      %分配变量空间

for k=1:len
    [att,vn,pos,wbib,fbsf]=trj(att,vn,pos,wt(k,:)',at(k,:)',Ts);
    trj_k(k,:) = [att;vn;pos;wbib;fbsf]';
    if mod(k,10/Ts)==0    %进度显示
        disp(k/(1/Ts))
    end
end
save trj_transfer trj_0 trj_k Ts
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
