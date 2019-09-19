function [RN, RM, Re]=Radius(Lat) 
R0 = 6.378388e6;
Rp = 6.356912e6;
e  = sqrt(1-(Rp/R0)^2);
RN = R0/sqrt(1-e^2*sin(Lat)^2);
RM = R0*(1-e^2)/(1-e^2*sin(Lat)^2)^(3/2);
Re = R0*(1-e*sin(Lat)^2); 
end