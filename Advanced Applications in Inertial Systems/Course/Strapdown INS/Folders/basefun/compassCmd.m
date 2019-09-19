function [vn, dpos, wnc] = compassCmd(fn, vn, vnr, kxy, ts, dpos, wnc, kz, wN, level) 
% vnr --外参考速度
global glv
    if nargin<7
        level = 1;
    end
    if level==1     % 水平调平
        dVE = vn(1) - vnr(1);
        vn(1) = vn(1) + (fn(1)-kxy(1)*dVE)*ts;
        dpos(1) = dpos(1) + dVE*kxy(3)*ts;
        wnc(2,1) = dVE*(1+kxy(2))/glv.Re + dpos(1);
        dVN = vn(2) - vnr(2);
        vn(2) = vn(2) + (fn(2)-kxy(1)*dVN)*ts;
        dpos(2) = dpos(2) + dVN*kxy(3)*ts;
        wnc(1,1) = -dVN*(1+kxy(2))/glv.Re - dpos(2);
        wnc(3,1) = 0;
    else            % 罗经对准
        dVE = vn(1) - vnr(1);
        vn(1) = vn(1) + (fn(1)-kxy(1)*dVE)*ts;
        dpos(1) = dpos(1) + dVE*kxy(3)*ts;
        wnc(2,1) = dVE*(1+kxy(2))/glv.Re + dpos(1);
        dVN = vn(2) - vnr(2);
        vn(2) = vn(2) + (fn(2)-kz(1)*dVN)*ts;
        wnc(1,1) = -dVN*(1+kz(2))/glv.Re;
        wnc(3,1) = (dVN*kz(3)*ts/wN+wnc(3,1))/(1+kz(4)*ts);
    end
