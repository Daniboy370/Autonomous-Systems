function [wbib, fbsf, wnie, gn, retp] = ImuStatic(qnb, pos, ts)
    if nargin<3
        ts = 1;
    end
    [wnie, wnen, gn, retp] = earth(pos);
    wbib = qmulv(qconj(qnb), wnie)*ts;
    fbsf = -qmulv(qconj(qnb), gn)*ts;
