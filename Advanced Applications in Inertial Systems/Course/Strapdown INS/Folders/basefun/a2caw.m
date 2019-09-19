function Caw=a2caw(att)
    si = sin(att(1)); ci = cos(att(1)); ti = si/ci;
    sj = sin(att(2)); cj = cos(att(2));
    Caw = [  cj, 0, sj; 
            sj*ti,  1, -ci/ti; 
            -sj/ci, 0, cj/ci ];
