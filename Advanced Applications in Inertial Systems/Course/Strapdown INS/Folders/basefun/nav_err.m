function err = nav_err(qnb, vn, pos, qnb0, vn0, pos0)
    if nargin<6
        trj_k = qnb0;
        qnb0 = a2qnb(trj_k(1,1:3)'); 
        vn0 = trj_k(1,4:6)'; 
        pos0 = trj_k(1,7:9)'; 
    end
    err = [qq2phi(qnb,qnb0); vn-vn0; pos-pos0];
