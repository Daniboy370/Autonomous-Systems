% 长时间纯惯导
clear all
glvs
Ts = 10;        % 采样周期
[qnb,vn,pos,qnb0,vn0,pos0] = nav_init([0;0;0]*glv.deg,0,34*glv.deg, ...
                                        [0.5;-0.5;3]*glv.min,0.01,10);
[wm, vm] = ImuStatic(qnb0, pos0, Ts);
[eb,web,db,wdb] = drift_bias([1;0;1;0]);
[wm,vm] = ImuAddErr(wm,vm,eb,web,db,wdb,Ts);
t = 50*3600;  % 总时间长度
len = fix(t/Ts);
err=zeros(len,9); 
kk = 1;
for k=1:len
    [qnb,vn,pos]=sins(qnb,vn,pos,wm,vm,Ts);    
    vn(3) = 0;  pos(3) = pos0(3); % 限定高度发散
    err(k,:) = nav_err(qnb,vn,pos,qnb0,vn0,pos0)';
    kk = kk+1;
    timedisp(k,Ts,3600);
end
time = [1:length(err)]*Ts/3600;
figure(2),
subplot(3,1,1),plot(time,err(:,1:3)/glv.min), ylabel('\it\phi\rm / arcmin'); grid on
subplot(3,1,2),plot(time,err(:,4:6)), ylabel('\it\delta V\rm / m/s');  grid on
subplot(3,1,3),plot(time,[err(:,7:8)*glv.Re,err(:,9)]), ylabel('\it\delta P\rm / m'); grid on
xlabel('\itt\rm / s'); 