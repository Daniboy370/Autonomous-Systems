function [qnb,vn,pos,qnb0,vn0,pos0] = nav_init(att0,vn0,pos0,phi,dvn,dpos)
global glv
    % 参数及单位格式化
    if exist('dpos')==0     % dpos
        dpos = 0;
    end
    if length(dpos)==1
        dpos = dpos*[1;1;1];
    end
    dpos = dpos.*[1/glv.Re; 1/glv.Re; 1];
    if exist('dvn')==0      % dvn
        dvn = 0;
    end
    if length(dvn)==1
        dvn = dvn*[1;1;1];
    end
    if exist('phi')==0        % phi
        phi = 0;
    end
    if length(phi)==1
        phi = phi*[1;1;1];
    end
    %%%
    if length(pos0)==1  % pos0
        pos0 = [pos0;0;0];
    end
    if length(vn0)==1   % vn0
        vn0 = vn0*[1;1;1];
    end
    if length(att0)==1   % att0
        att0 = att0*[1;1;1];
    end
    % 赋值
    qnb0 = a2qnb(att0); qnb = qaddphi(qnb0,phi);
    vn = vn0 + dvn;
    pos = pos0 + dpos;
