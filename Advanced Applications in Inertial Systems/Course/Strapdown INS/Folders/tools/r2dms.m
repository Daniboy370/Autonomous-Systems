function dms=r2dms(r)
global glv
    d = r/glv.deg;
	m = (d-fix(d))*60; 
	s = (m-fix(m))*60;
	dms = fix(d)*10000.0+fix(m)*100.0+s;
