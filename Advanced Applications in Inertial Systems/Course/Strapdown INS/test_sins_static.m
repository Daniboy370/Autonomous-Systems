clear all
glvs
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;0]*glv.deg,0,0*glv.deg, [0.5;-0.5;3]*glv.min,0.01,10);
[wbib, fbsf] = ImuStatic(qnb0, pos0);
Ts = 0.1;        %��������
n = 3;    % ������
t = 3600;  % ��ʱ�䳤��
len = fix(t/Ts);
wm = repmat(wbib'*Ts,len,1);
vm = repmat(fbsf'*Ts,len,1);
[eb,web,db,wdb] = drift_bias([1;1;1;1]);
[wm,vm] = ImuAddErr(wm,vm,eb,web,db,wdb,Ts);
err=zeros(len/n,9); 
kk = 1;
for k=1:n:(len-n+1)
    [qnb,vn,pos]=sins(qnb,vn,pos,wm(k:k+n-1,:)',vm(k:k+n-1,:)',Ts);    
    vn(3) = 0;  % �޶��߶ȷ�ɢ
    err(kk,:) = nav_err(qnb,vn,pos,qnb0,vn0,pos0)';
    kk = kk+1;
    timedisp(k,Ts,100);
end
time = [1:length(err)]*Ts*n;
figure;
subplot(3,1,1),plot(time,err(:,1:3)/glv.min), ylabel('\it\phi\rm / arcmin'); grid on
subplot(3,1,2),plot(time,err(:,4:6)), ylabel('\it\delta V\rm / m/s');  grid on
subplot(3,1,3),plot(time,[err(:,7:8)*glv.Re,err(:,9)]), ylabel('\it\delta P\rm / m'); grid on
xlabel('\itt\rm / s'); 