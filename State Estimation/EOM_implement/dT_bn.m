function dT = dT_bn
%% *********************** d_Orientation *********************** %
global T_b_n Omg_ib_b Omg_ie_n Omg_en_n i

dT  = T_b_n(:,:,i)*Omg_ib_b - ( Omg_ie_n + Omg_en_n )*T_b_n(:,:,i);

end