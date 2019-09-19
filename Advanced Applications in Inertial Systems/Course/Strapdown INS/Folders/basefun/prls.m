function [phit, phi0] = prls(aEN, lti, t)
global glv
    sl = sin(lti); cl = cos(lti); tl = sl/cl;
    wN = glv.wie*cl; wU = glv.wie*sl;
    a1E = aEN(1); a2E = aEN(2); a3E = aEN(3); a1N = aEN(4); a2N = aEN(5); a3N = aEN(6);
    
    uE = a2N/glv.g0; uN = -a2E/glv.g0; uU = uN*tl-a3N/(glv.g0*wN);
    phiE0 = a1N/glv.g0; phiN0 = -a1E/glv.g0; phiU0 = phiN0*tl-uE/wN;
    
    phiE = phiE0 + t*uE + t^2/2*(wU*uN-wN*uU);
    phiN = phiN0 + t*uN - t^2/2*wU*uE;
    phiU = phiU0 + t*uU + t^2/2*wU*uE;
    
    phi0 = [phiE0; phiN0; phiU0]; phit = [phiE; phiN; phiU];
