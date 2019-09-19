function F = F_matrix( X, T_n_b )
% -------------------------- Description ------------------------- %
%                                                                  %
%           This function computes the Process matrix              %
%                                                                  %
% --------------------------- Content ---------------------------- %

global f_n_INS g om_ie om_n_in Re Rm Rn

[phi, ~, h]  = deal(X(1), X(2), X(3));
[vn, ve, vd] = deal(X(4), X(5), X(6));

% ------------------ Position Error State ------------------  %
Frr=[0 0 -vn/(Rm+h)^2;
    ve*sin(phi)/((Rn+h)*cos(phi)^2) 0 -ve/((Rn+h)^2*cos(phi));
    0 0 0];

Frv=[1/(Rm+h)   0                   0;
     0          1/((Rn+h)*cos(phi)) 0;
     0          0                   -1];

Fre = zeros(3, 3);

% ------------------ Velocity Error State ------------------  %
Fvr=[-2*ve*om_ie*cos(phi)-ve^2/((Rn+h)*cos(phi)^2), 0,...
    -vn*vd/(Rm+h)^2+ve^2*tan(phi)/(Rn+h)^2;
    % ----------------------------------- %
    2*om_ie*(vn*cos(phi)-vd*sin(phi))+ve*vn/((Rn+h)*cos(phi)^2), 0, ...
    -ve*vd/(Rn+h)^2-vn*ve*tan(phi)/(Rn+h)^2;
    % ----------------------------------- %
    2*ve*om_ie*sin(phi), 0, ve^2/(Rn+h)^2 + vn^2/(Rm+h)^2-2-2*g/(Re+h)];

Fvv=[vd/(Rm+h), -2*om_ie*sin(phi)-2*ve*tan(phi)/(Rn+h), vn/(Rm+h);
    % ----------------------------------- %
    2*om_ie*sin(phi)+ve*tan(phi)/(Rn+h), (vd + vn*tan(phi))/(Rn+h),...
    2*om_ie*cos(phi)+ve*tan(phi)/(Rn+h); 
    % ----------------------------------- %
    -2*vn/(Rm+h), -2*om_ie*cos(phi) - 2*ve/(Rn+h), 0];

Fve = skew(-f_n_INS);                 % acc. in navigation frame

% ---------------- Misalignment Error State ----------------  %
Fer = [ -om_ie*sin(phi), 0, -ve/(Rn+h)^2;
    0 , 0 , vn/(Rm+h)^2;
    -om_ie*cos(phi) - ve/((Rn+h)*cos(phi)^2), 0 , ve*tan(phi)/(Rn+h)^2];

Fev = [0, 1/(Rn+h) , 0;
    -1/(Rm+h), 0 , 0;
    0 , -tan(phi)/(Rn+h), 0];

Fee = -skew(om_n_in);

% ---------------- Bias matrix coefficients ----------------- %
tau_a = 1; tau_g = 1;             % (!) Clarify magnitudes (!)
O_3x3 = zeros(3);
Fa = -(1/tau_a)*eye(3); 
Fg = -(1/tau_g)*eye(3); 

% ----------------- Augmented Error State ------------------- %
F = [Frr   Frv   Fre   O_3x3 O_3x3;
     Fvr   Fvv   Fve   T_n_b O_3x3;
     Fer   Fev   Fee   O_3x3 T_n_b;
     O_3x3 O_3x3 O_3x3 Fa    O_3x3;
     O_3x3 O_3x3 O_3x3 O_3x3 Fg  ];
 
end