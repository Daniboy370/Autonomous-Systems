function timedisp(k, ts, inteval)
% ╫Ь╤хотй╬
    if mod(k*ts, inteval)<0.9*ts
        disp(k*ts)
    end