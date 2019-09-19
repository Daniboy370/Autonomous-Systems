function [att, aa, bb] = align_i0_1(wm, vm, pos, ts)
% 基于惯性系的初始对准算法
global glv
    len = length(wm);
    [wnie, wnen, gn, retp] = earth(pos);
    qib0b = [1; 0; 0; 0];
    vib0 = zeros(3,1); vi0 = zeros(3,1); 
    pib0 = zeros(3,1); pi0 = zeros(3,1);
    pib0k = zeros(size(wm)); pi0k = pib0k;  aa=pi0k; bb=aa;
    att = zeros(size(wm));
    k0 = fix(10/ts); % 从10s后开始计算
    for k=1:len
        [phim, dvbm] = cnscl(wm(k,:)', vm(k,:)');
        vib0 = vib0 - qmulv(qib0b, dvbm);
        vi0 = vi0 + [retp.cl*cos(k*ts*glv.wie);retp.cl*sin(k*ts*glv.wie);retp.sl]*gn(3)*ts;
        qib0b = qmul(qib0b, rv2q(phim));
        pib0 = pib0 + vib0*ts; 
        pi0 = pi0 + vi0*ts;
        pib0k(k,:) = pib0'; pi0k(k,:) = pi0'; 
    aa(k,:)=-qmulv(qib0b, dvbm)'; 
    bb(k,:)=[retp.cl*cos(k*ts*glv.wie);retp.cl*sin(k*ts*glv.wie);retp.sl]'*gn(3)*ts;
        if k>k0
            k1 = fix(k/2);
            swiet = sin(k*ts*glv.wie); cwiet = cos(k*ts*glv.wie);
            Cni0 = [-swiet,cwiet,0; 
                -retp.sl*cwiet,-retp.sl*swiet,retp.cl; 
                retp.cl*cwiet,retp.cl*swiet,retp.sl];
            qni0 = m2qnb(Cni0);
            Ci0ib0 = dv2atti(pi0k(k1,:)', pi0, pib0k(k1,:)', pib0);
            qi0ib0 = m2qnb(Ci0ib0);
            qnb = qmul(qmul(qni0,qi0ib0),qib0b);
            att(k,:) = q2att(qnb)';
       end
    end
