glvs
ts = 1;
t = 24*3600;
L = 34*glv.deg;
eb = [1;-1;1]*0.01*glv.dph;
db = [-1;1;0]*50*glv.ug;
dV = [0;0]; dL = 0; dla = 0; phi = [0;0;0]*glv.min;
X = [0;0; dL; phi];
wN = glv.wie*cos(L); wU = glv.wie*sin(L);
g = glv.g0; R = glv.Re; tL = tan(L); secL = sec(L);
F = [0 2*wU 0 0 -g 0
    -2*wU 0 0 g 0 0
    0 1/R 0 0 0 0 
    0 -1/R 0 0 wU -wN
    1/R 0 -wU -wU 0 0
    tL/R 0 wN wN 0 0 ];
Fk = eye(6)+F*ts;
U = [db(1:2); 0; -eb];
err = zeros(t/ts,7); kk=1;
for k=1:ts:t
    X = Fk*X + U*ts;
    dla = dla + X(1)*secL/R;
    err(kk,:) = [X(4:6);X(1:3);dla]'; kk=kk+1;
end
figure;
time = [1:ts:t]/3600;
subplot(221),plot(time,err(:,1:3)/glv.min); grid on
subplot(222),plot(time,err(:,4:5)); grid on
subplot(223),plot(time,err(:,6:7)/glv.min); grid on
subplot(224),plot(time,...
    [-err(:,1:3)+[-err(:,6),err(:,7)*cos(L),err(:,7)*sin(L)]]/glv.min); grid on