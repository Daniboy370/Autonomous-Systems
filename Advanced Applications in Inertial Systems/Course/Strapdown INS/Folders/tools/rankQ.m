function [n,Q] = rankQ(Ft, H)
    Q = H;
    for k=1:length(Ft)-1
        Q = [Q; H*Ft^k];
    end
    n = rank(Q);