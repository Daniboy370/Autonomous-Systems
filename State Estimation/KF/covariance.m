function M = covariance ( V, flag )

len = length(V);
M = zeros(len);

for j = 1:len
    for i = 1:len
        M(j, i) = V(j)*V(i);
    end
end

if flag == 1
    M = diag( diag( M ) );
end