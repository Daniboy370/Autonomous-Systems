function [att, vn, pos, wbib, fbsf] = trj(att_1, vn_1, pos_1, wt, at, h)        
	si = sin(att_1(1)); ci = cos(att_1(1)); 
    sj = sin(att_1(2)); cj = cos(att_1(2)); 
    sk = sin(att_1(3)); ck = cos(att_1(3));        
    Cbn = [ cj*ck-si*sj*sk, cj*sk+si*sj*ck, -ci*sj;
           -ci*sk,          ci*ck,           si;
            sj*ck+si*cj*sk, sj*sk-si*cj*ck,  ci*cj ];
	Cnt = [ ck, -ci*sk,  si*sk; 
            sk,  ci*ck, -si*ck; 
            0,   si,     ci ];
    a2w = [ cj, 0, -sj*ci; 
            0,  1,  si; 
            sj, 0,  cj*ci ];
        
    [wnie, wnen, gn, retp] = earth(pos_1, vn_1);
    att = att_1+wt*h;
	vn = vn_1+Cnt*at*h;   vn_12 = (vn_1+vn)/2;
    pos = pos_1+[vn_12(2)/retp.rmh;vn_12(1)/(retp.rnh*retp.cl);vn_12(3)]*h;
	wbib = Cbn*(wnie+wnen) + a2w*wt;
  	fbsf = Cbn * (Cnt*at+cross(2*wnie+wnen,vn_1)-gn);
