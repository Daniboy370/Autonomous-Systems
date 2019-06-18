%% ------------------ 4. Triangulate a Landmark ------------------ %
% ------------- Extracting Images from Rosbag ------------- %
bag = rosbag('rosbag_ac.bag');
bag_imgs  = select(bag,'Topic','/camera/rgb/image_raw/compressed');
all_imgs = readMessages(bag_imgs);

% ----------- Triangulation - 3 Images with L ------------- %
N_i = [1 32 96];

for i=1:length(N_i)
    figure(i); imshow( readImage( all_imgs{N_i(i)} ) );
    [pix_i(i,1), pix_i(i,2)]  = ginput;
end

[pix_1 pix_2 pix_3] = deal( pix_i(1,:), pix_i(2,:), pix_i(3,:) );
u = pix_i(:,1); v = pix_i(:,2);