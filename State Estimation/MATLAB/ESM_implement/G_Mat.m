function G = G_Mat
% -------------------- Augmented Error State -------------------- %
global w_agm w_ggm

d_f = -b_a/tau_a + w_agm;      
d_omg = -b_g/tau_g + w_ggm;

G = [d_f d_omg]';
end
