function r=dms2r(dms)
global glv
	d = fix(dms/10000.0);
	m = fix((dms-d*10000.0)/100.0); 
	s = dms-d*10000.0-m*100.0;
	r = d*glv.deg+m*glv.min+s*glv.sec;
