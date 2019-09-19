function g = g_calc( phi, h )
% -------------------------- Description ------------------------- %
%                                                                  %
%     This function computes actual gravity given phi and h        %
%                                                                  %
% --------------------------- Content ---------------------------- %

Rp = 6.356912e6;
R0 = 6.378388e6;
e = sqrt(1-(Rp/R0)^2);
f = 1-(Rp/R0);
theta = atan2(tan(phi)*(1-f)^2,0);
Re = R0*(1-e*(sin(theta))^2);

g = 9.780327*(1+0.0053024*(sin(phi))^2)*(1-2*(h/Re));

end

