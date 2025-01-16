function Results_segment = ersForHID(Y,K)
%% Obtain principle components
[M, N, C] = size(Y);
p = 1; % number of principle components
[X_pca] = pca(reshape(Y, M*N, C), p);
img = im2uint8(mat2gray(reshape(X_pca', M, N, p)));
%% Superpixel segmentation
labels = mex_ers(double(img), K);
% imshow(labels/K);
Results_segment= seg_im_class(Y, labels);
end

