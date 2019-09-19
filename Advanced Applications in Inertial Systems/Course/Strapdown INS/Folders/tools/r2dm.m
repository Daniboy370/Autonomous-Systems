function dm=r2dm(r)
global glv
	d = r/glv.deg;
	m = (d-fix(d))*60; 
	dm = fix(d)*100.0+m;
