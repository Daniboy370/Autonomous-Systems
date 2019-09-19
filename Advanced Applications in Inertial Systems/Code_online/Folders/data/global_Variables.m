global e om_ie Re Rp om_e_ie
% -------------------------- Description ------------------------- %
%                                                                  %
%           This script uploads geographical parameters            %
%                                                                  %
% --------------------------- Content ---------------------------- %
f = 1/298.257;                              % earth flattening rate
e = sqrt(2*f-f^2);                          % Eccentricity of ellipsoid
Re = 6378137;                               % Earth Radius (GPS-84)
Rp = Re*(1-f);                              % Ellipticity of the Earth
om_ie = 7.2921151467e-5;                    % Earth rotation rate
om_e_ie = [0 0 om_ie]';                     % Project on INS
