function Cnb=a2cnb(att)
    si = sin(att(1)); ci = cos(att(1)); 
    sj = sin(att(2)); cj = cos(att(2)); 
    sk = sin(att(3)); ck = cos(att(3));
    Cnb = [ cj*ck-si*sj*sk, -ci*sk,  sj*ck+si*cj*sk;
         cj*sk+si*sj*ck, ci*ck, sj*sk-si*cj*ck;
         -ci*sj,          si,     ci*cj ];
