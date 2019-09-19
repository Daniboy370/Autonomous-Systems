function r=dm2r(dm)
global glv
	d = fix(dm/100.0);
	m = dm-d*100.0; 
	r = d*glv.deg+m*glv.min;
