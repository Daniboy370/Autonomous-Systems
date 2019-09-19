function G = G_matrix( T_n_b )
% -------------------------- Description ------------------------- %
%                                                                  %
%            This function computes the control matrix             %
%                                                                  %
% --------------------------- Content ---------------------------- %

[O_3x3, I_3x3] = deal(zeros(3), eye(3) );     % Fill in entries

% ------------------ Augmented Control matrix -------------------- %
G = [O_3x3  O_3x3  O_3x3  O_3x3;
     T_n_b  O_3x3  O_3x3  O_3x3;
     O_3x3  T_n_b  O_3x3  O_3x3;
     O_3x3  O_3x3  I_3x3  O_3x3;
     O_3x3  O_3x3  O_3x3  I_3x3];
 
end