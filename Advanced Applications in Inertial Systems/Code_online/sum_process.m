function sum_process( X, i, time_f )
% -------------------------- Description ------------------------- %
%                                                                  %
%     Validation function for earth distance between Meridians     %
%                                                                  %
% --------------------------- Content ---------------------------- %
global e Re

% ------------------- Locations for validation ------------------- %
% lat1 = 32.77611;      lon1 = 35.022366; % Technion
% lat2 = 33.31522;      lon2 = 44.366071; % Baghdad 
% lat2 = 32.91613;      lon2 = 35.292520; % Karmiel
% lat2 = 32.804446;      lon2 = 35.521638; % Tiberias
% [distance_on_earth, az] = distance([lat1 lon1], [lat2 lon2], [Re e])

% distance_on_earth = distance([X(1, 1) X(1, 2)], [X(i, 1) X(i, 2)], [Re e]);
[M_i, M_f] = deal([X(1, 1), X(1, 2)], [X(i, 1), X(i, 2)]);
distance_on_earth = Lat_Lon_distance([X(1, 1) X(1, 2)], [X(i, 1) X(i, 2)]);

% distance_on_earth = distance([X(1, 1) X(1, 2)], [X(i, 1) X(i, 2)]) ;
disp('* -------------------- Trajectory sum -------------------- *');
disp('   Initial coordinates                Final coordinates');
fprintf('   [%.5f, %.5f]               [%.5f, %.5f]\n',  rad2deg(M_i), rad2deg(M_f)) 
fprintf('   Earth distance : %.2f [m]        Duration : %.2f [sec]. \n', distance_on_earth, time_f(i+1) );

% ---- Ready made distance computation ---- %
%     Vn = X(i+1, 4:6)
%     dist = Lat_Lon_distance([X(i+1, 1) X(i+1, 2)], [X(i, 1) X(i, 2)], [Re e])
