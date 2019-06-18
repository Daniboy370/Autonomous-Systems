%% --------------- 5.a.b The importance of diversity --------------- %
% --------------------- Load Data Automatically --------------------- %
r1 = [5 18 20]; r2 = [24 26 27]; r3 = [30 32 34]; r4 = [96 100 115];
N_i = [r1; r2; r3; r4];
load('u_5'); load('v_5');

flag = 0;                                % 0 - Mo-cap, 1 - Odometry
for k=1:4
    for i=1:3
        % --------- Manual pixel input : used only once -------- %
%         figure(i); imshow( readImage( allMsgs{N_i(k,i)} ) );
%         [u(k,i), v(k,i)] = ginput;
        % -------- Obtain SPECIFIC Transformation Matrix ------- %
        T_w2c = GetTranslationMat(N_i(k,i), bag, flag);
        M = K*T_w2c(1:3,:);                  % M : Projection Matrix
        run_i(3*(k-1)+i) = N_i(k,i);
        % ------------- Form A x = b linear system ------------- %
        b( (2*(i+k-1)-1):(2*(i+k-1)),1) = [-u(k,i)*M(3,4) + M(1,4); -v(k,i)*M(3,4) + M(2,4) ];
        
        A( (2*(i+k-1)-1):(2*(i+k-1)),:) = [u(k,i)*M(3,1)-M(1,1),  u(k,i)*M(3,2)-M(1,2),  u(k,i)*M(3,3)-M(1,3);
            v(k,i)*M(3,1)-M(2,1),  v(k,i)*M(3,2)-M(2,2),  v(k,i)*M(3,3)-M(2,3)];
        
        if flag == 0
            X_Mo_cap_i(:,3*(k-1)+i) = inv(A'*A)*A'*b;
            err_Mo_cap(3*(k-1)+i) = norm( Lnd_2 - X_Mo_cap_i );
        else
            X_Odom_i(:,3*(k-1)+i) = inv(A'*A)*A'*b;
            err_Odom(3*(k-1)+i)   = norm( Lnd_2 - X_Odom_i   );
        end
    end
    
    if flag == 0
        X_Mo_cap = inv(A'*A)*A'*b;
        err_Mo_cap(k) = norm( Lnd_2 - X_Mo_cap );
    else
        X_Odom = inv(A'*A)*A'*b;
        err_Odom(k) = norm( Lnd_2 - X_Odom );
    end
end

hold on; X_norm_O = zeros(1,12); X_norm_M = X_norm_O;
for i=1:length(run_i)
    if flag == 0
        X_norm_M(i)=(sum(run_i(1:i))*sum(err_Mo_cap(1:i)))/sum(run_i(1:i));
    else
        X_norm_O(i)=(sum(run_i(1:i))*sum(err_Mo_cap(1:i)))/sum(run_i(1:i));
    end
end
