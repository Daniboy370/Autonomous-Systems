function qnb = m2qnb(Cnb)
    qnb = [                       sqrt(abs(1.0 + Cnb(1,1) + Cnb(2,2) + Cnb(3,3)))/2.0;
        sign(Cnb(3,2)-Cnb(2,3)) * sqrt(abs(1.0 + Cnb(1,1) - Cnb(2,2) - Cnb(3,3)))/2.0;
        sign(Cnb(1,3)-Cnb(3,1)) * sqrt(abs(1.0 - Cnb(1,1) + Cnb(2,2) - Cnb(3,3)))/2.0;
        sign(Cnb(2,1)-Cnb(1,2)) * sqrt(abs(1.0 - Cnb(1,1) - Cnb(2,2) + Cnb(3,3)))/2.0 ]; 
