function [Phi_0, Lam_0, h, psi_0] = initial_properties( r_GPS, good_i )
% -------------------------- Description ------------------------- %
%                                                                  %
%           Extraction of initial Euler (body) angles              %
%                                                                  %
% --------------------------- Content ---------------------------- %

[Phi_0, Lam_0, h] = deal( r_GPS(1, 1), r_GPS(1, 2), r_GPS(1, 3) );

% input : good_i == Sufficient number of steps away from inital 
% orientation in order to compute opposite azimuth between 2 points

[qq, az] = distance([r_GPS(1, 1) r_GPS(1, 2)], [r_GPS(good_i, 1) r_GPS(good_i, 2)]);

if az < 1e-3
   psi_0 = 0;
else
    psi_0 = deg2rad(az);
end