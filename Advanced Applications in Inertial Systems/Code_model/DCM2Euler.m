%% DCM2Euler
function [ phi,theta,psi] = DCM2Euler( Eul_matrix )
    theta=asin(-Eul_matrix(1,3));
    phi=atan2(Eul_matrix(2,3),Eul_matrix(3,3));
    psi=atan2(Eul_matrix(1,2),Eul_matrix(1,1));

end