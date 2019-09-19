function Cne = p2cne(pos)
    slti = sin(pos(1)); clti = cos(pos(1));
    slgi = sin(pos(2)); clgi = cos(pos(2));
    Cne = [ -slgi, clgi, 0
        -slti*clgi, -slti*slgi, clti
        clti*clgi, clti*slgi, slti ];
