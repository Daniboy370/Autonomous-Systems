function [d1km d2km] = Lat_Lon_distance(Lat_Lon_1, Lat_Lon_2)

% Inputs:
%   latlon1: latlon of origin point [lat lon]
%   latlon2: latlon of destination point [lat lon]
%
% Outputs:
%   d1km: distance calculated by Haversine formula
%   d2km: distance calculated based on Pythagoran theorem
global Re

[lat1, lat2] = deal( Lat_Lon_1(1), Lat_Lon_2(1) );
[lon1, lon2] = deal( Lat_Lon_1(2), Lat_Lon_2(2) );
deltaLat = lat2 - lat1;
deltaLon = lon2 - lon1;
a = sin((deltaLat)/2)^2 + cos(lat1)*cos(lat2) * sin(deltaLon/2)^2;
c = 2*atan2(sqrt(a),sqrt(1-a));
d1km = Re*c;                        %Haversine distance
x = deltaLon*cos((lat1+lat2)/2);
y = deltaLat;
d2km = Re*sqrt(x*x + y*y);          %Pythagoran distance

end