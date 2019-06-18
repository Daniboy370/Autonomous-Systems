%% --------- Reconstruction using Odometry / Mocap Triangulation --------- %
flag = 1;                               % Set for both methods                             
for j=1:2                               % 0 - Mo-cap, 1 - Odometry
    clear A b M 
    for i=1:length(N_i)
        % -------- Obtain SPECIFIC Transformation Matrix ------- %
        T_w2c = GetTranslationMat(N_i(i), bag, j-flag);
        M = K*T_w2c(1:3,:);              % M : Projection Matrix
        % ------------- Form A x = b linear system ------------- %
        b((2*i-1):(2*i),1)=[-u(i)*M(3,4) + M(1,4); -v(i)*M(3,4) + M(2,4)];
        
        A( (2*i-1):(2*i),:) = [u(i)*M(3,1)-M(1,1), u(i)*M(3,2)-M(1,2), u(i)*M(3,3)-M(1,3);
            v(i)*M(3,1)-M(2,1),  v(i)*M(3,2)-M(2,2),  v(i)*M(3,3)-M(2,3)];
    end
    
    if j-flag == 0
        X_Mo_cap = inv(A'*A)*A'*b
        err_Mo_cap = norm( Lnd_2 - X_Mo_cap )
    else
        X_Odom = inv(A'*A)*A'*b
        err_Odom   = norm( Lnd_2 - X_Odom   )
    end
end