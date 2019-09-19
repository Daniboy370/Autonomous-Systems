function Cwa=a2cwa(att)
    si = sin(att(1)); ci = cos(att(1)); 
    sj = sin(att(2)); cj = cos(att(2)); 
    Cwa = [  cj, 0, -sj*ci; 
            0,  1, si; 
            sj, 0, cj*ci ];
