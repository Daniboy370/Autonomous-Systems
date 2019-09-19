function [hms, str] = s2hms(s)
global glv
    h = fix(s/3600);
	s = (s-h*3600);
    m = fix(s/60);
    s = (s-m*60);
    hms = h*10000+m*100+s;
    str = sprintf('%02d:%02d:%02d', h, m, s);
