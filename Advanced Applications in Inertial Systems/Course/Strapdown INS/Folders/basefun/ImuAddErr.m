function [wm, vm] = ImuAddErr(wm, vm, eb, web, db, wdb, ts)

[m, n] = size(wm); sts = sqrt(ts);

if n==1  % ÊäÈëwm,vmÎªÁÐÏòÁ¿
    wm = wm + eb*ts + web.*randn(3,1)*sts;
    vm = vm + db*ts + wdb.*randn(3,1)*sts;
else
    wm = wm + [ts*eb(1)+sts*web(1)*randn(m,1), ts*eb(2)+sts*web(2)*randn(m,1), ts*eb(3)+sts*web(3)*randn(m,1)];
    vm = vm + [ts*db(1)+sts*wdb(1)*randn(m,1), ts*db(2)+sts*wdb(2)*randn(m,1), ts*db(3)+sts*wdb(3)*randn(m,1)];
end