clear all; close all; clc;
glvs

% -------------- Initialization -------------- %
ts = 0.1; t = 1000;
len = fix(t/ts);
gyro = zeros(len,3); acc = gyro;

% -------------- Initialization -------------- %
[eb, web, db, wdb] = drift_bias([0; 1; 0; 1]);
[gyro, acc] = ImuAddErr(gyro, acc, eb, web, db, wdb, ts);
gyro = incre(gyro, 1); acc = incre(acc, 1);

figure;
tt = [1:len]*ts; gg = web(1)*sqrt(tt); aa = wdb(1)*sqrt(tt);
subplot(211), plot(tt, gyro/glv.sec, tt,[gg;-gg]/glv.sec,'k--'), grid on
title('Attitude Error'); xlabel('t [ s ]'); ylabel('\Delta\theta / arcsec');
subplot(212), plot(tt, acc, tt, [aa;-aa], 'k--'), grid on
title('Velocity Error'); xlabel('t [ s ]'); ylabel('\DeltaV  [m/s]');
