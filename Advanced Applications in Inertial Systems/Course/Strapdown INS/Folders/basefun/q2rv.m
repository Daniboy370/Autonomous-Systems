function v = q2rv(q) 
	if(q(1)<0)
	    q = -q;
	end  
    n2 = acos(q(1));
    if n2>1e-100
        k = 2*n2/sin(n2);
    else
        k = 2;
    end
    v = k*q(2:4);