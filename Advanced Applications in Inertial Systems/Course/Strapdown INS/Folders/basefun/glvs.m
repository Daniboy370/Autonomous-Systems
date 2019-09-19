global glv
glv.Re = 6378137;                           % Earth Radius (GPS-84)
glv.f = 1/298.257;                          % earth flattening rate
glv.Rp = (1-glv.f)*glv.Re;                  % other geometric parameters such as the ellipticity of the Earth
glv.e = sqrt(2*glv.f-glv.f^2); glv.e2 = glv.e^2;
glv.ep = sqrt(glv.Re^2+glv.Rp^2)/glv.Rp; glv.ep2 = glv.ep^2;
glv.wie = 7.2921151467e-5;                  % Earth rotation rate
glv.meru = glv.wie/1000;                    % turnover rate
glv.g0 = 9.7803267714;                      % gravitational acceleration
glv.mg = 1.0e-3*glv.g0;                     % milligravity acceleration
glv.ug = 1.0e-6*glv.g0;                     % microgravity acceleration
glv.ugpg2 = glv.ug/glv.g0^2;                % plus table quadratic coefficient
glv.ws = 1/sqrt(glv.Re/glv.g0);             % Hula angle frequency
glv.ppm = 1.0e-6;                           % one millionth
glv.deg = pi/180;                           % angle
glv.min = glv.deg/60;                       % angle
glv.sec = glv.min/60;                       % angular seconds
glv.hour = 3600;                            % hour
glv.dps = pi/180/1;                         % degrees / sec
glv.dph = glv.deg/glv.hour;                 % degrees / hour
glv.dpss = glv.deg/sqrt(1);                 % degrees/sqrt(seconds)
glv.dpsh = glv.deg/sqrt(glv.hour);          % degrees/sqrt(hours), angular random walk coefficient
glv.Hz = 1/1;                               % Hertz (1/s)
glv.ugpsHz = glv.ug/sqrt(glv.Hz);           % ug/sqrt(Hz), random walk coefficient
glv.mil = 2*pi/6000;                        % secret
glv.nm = 1853;                              % nautical miles
glv.kn = glv.nm/glv.hour;                   % section
glv.cs = [                                  % cone and rowing error compensation factor
    2./3,       0,          0,          0
    9./20,      27./20,     0,          0
    54./105,    92./105,    214./105,    0
    250./504,   525./504,   650./504,   1375./504 ];