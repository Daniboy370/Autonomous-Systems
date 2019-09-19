function res = meann(scr, n, dim)
    if nargin<3
        dim = 1;
    end
    if dim>1
        scr = scr';
    end
    [p,q] = size(scr);
    k = fix(p/n);
    res = zeros(k,q);
    for j=1:k
        res(j,:) = mean(scr((j-1)*n+1:j*n,:),1);
    end
    if dim>1
        res = res';
    end
