function w = incre(w, ts)
% �����ۼ�����������cumsum����
    for k = 2:length(w)
        w(k,:) = w(k-1,:) + w(k,:);
    end
    w = w * ts;