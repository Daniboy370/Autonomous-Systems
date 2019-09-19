function w = incre(w, ts)
% 计算累计增量，可用cumsum函数
    for k = 2:length(w)
        w(k,:) = w(k-1,:) + w(k,:);
    end
    w = w * ts;