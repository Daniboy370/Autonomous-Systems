clc; clear all; close all;
% ------------ 1. Projection of a 3D point ------------ %
% 1.a Camera's Projection Matrix
% Calibration Matrix
K     = [480 0  320;                    
         0  480 270;
         0   0   1];
% Rotation Matrix
R_G_C = [   0.5363  -0.8440  0 ;
            0.8440   0.5363  0 ;
            0        0       1];
% Translation from Camera to Global
t_C_G = [-451.2459 257.0322 400]';
% Translation from Global to Camera
t_G_C = R_G_C*t_C_G;
% Camera Pose   
Proj = K*[R_G_C t_G_C];
% 3D Global Point
l_G   = [350, -250, -35]';
% Homogenous Coordinates
P = Proj*[l_G; 1]              
[u_t, v_t, w_t] = deal(P(1), P(2), P(3))
% Conversion to Pixels
[u, v] = deal(u_t/w_t, v_t/w_t);
[u, v]

%% ---------------------- Part 2 ---------------------- %
clc; clear all; close all;

% ---------- a. Capture 2 Images of yourself ---------- %
I_add_1 = 'C:\Users\Daniel\Desktop\Vision Aided Navigation\Hw_i\Hw_2\Img_0.jpg';
I_add_2 = 'C:\Users\Daniel\Desktop\Vision Aided Navigation\Hw_i\Hw_2\Img_1.jpg';

I = imread(I_add_2);                        % Read the Image address
I = imrotate(I, 90);                        % Rotate Image
scale = 0.25;                               % New Image scale
I = imresize(I, scale);                     % Scale down Image
figure('Color','white','rend','painters','pos',[2000 20 500 700]); 
image(I);

% ----- b. Compute the SIFT frames and descriptors ----- %
I = single(rgb2gray(I));
% [f, d] = vl_sift(I);
perm = randperm(size(f,2)) ;
sel = perm(1:80) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;

% ------------------ Custom Frames ------------------ %
fc = [100;100;10;-pi/8] ;
[f,d] = vl_sift(I,'frames',fc) ;
fc = [100;100;10;0] ;
[f,d] = vl_sift(I,'frames',fc,'orientations') ;

%% Basic matching - SIFT descriptors
clc; clear all; close all;
Ia = imread('C:\Users\Daniel\Desktop\Vision Aided Navigation\Hw_i\Hw_2\Img_0.jpg');
Ib = imread('C:\Users\Daniel\Desktop\Vision Aided Navigation\Hw_i\Hw_2\Img_1.jpg');

scale = 0.5;
Ia = imresize(Ia,scale);
Ib = imresize(Ib,scale);
[fa,da] = vl_sift(im2single(rgb2gray(Ia))) ;
[fb,db] = vl_sift(im2single(rgb2gray(Ib))) ;
[matches, scores] = vl_ubcmatch(da, db) ;

% Detector parameters - The SIFT detector is controlled mainly 
% by two parameters: the peak threshold and the (non) edge threshold.
I = double(rand(100,500) <= .005) ;
I = (ones(100,1) * linspace(0,1,500)) .* I ;
I(:,1) = 0 ; I(:,end) = 0 ;
I(1,:) = 0 ; I(end,:) = 0 ;
I = 2*pi*4^2 * vl_imsmooth(I,4) ;
I = single(255 * I) ;



