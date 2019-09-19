function T_n_e = R_n_e(lat, lat)
% -------------------------- Description ------------------------- %
%                                                                  %
%              Convert ECEF to Navigatgion frame (LLLN)            %
%                                                                  %
% --------------------------- Content ---------------------------- %

T_n_e = [-sin(lat)*cos(lat),    -sin(lat)*sin(lat),  cos(lat);
    -sin(lat),             cos(lat),                   0;
    -cos(lat)*cos(lat),    -cos(lat)*sin(lat), -sin(lat)];

end