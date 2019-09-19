function [Pn,Pe,Pd,X,Y,Z] =  LLLN2NED(Lat,Alt,dLat,dLong,dAlt,RN,RM)
    Pn = dLat*(RM+Alt);
    Pe = dLong*(RN+Alt)*cos(Lat);
    Pd = -dAlt;
    X  = Pe;
    Y  = Pn;
    Z  = Alt;
end