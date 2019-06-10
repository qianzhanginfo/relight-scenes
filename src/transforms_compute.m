function A = transforms_compute(S, T, patch_size)
% Compute local linear transforms based on correspondences
% Closed-form equation of transforms ref: Yichang Shih "Data-driven 
% Hallucination for Different Times of Day from a Single Outdoor Photo" 

% get corresponding patches
patch_s = get_corres_patch(patch_size, S.im, S.corres);
patch_t = get_corres_patch(patch_size, T.im, T.corres);
   
% compute global linear matrix G
G = patch_t * pinv(patch_s); % global matrix 
gamma = 0.01;
Id3 = eye(3);

% compute local color transforms
num_corres = size(patch_s,2)/(patch_size*patch_size);
num_patch_pixels = patch_size * patch_size;

patch_s3 = reshape(patch_s, [3, num_patch_pixels, num_corres]);
patch_t3 = reshape(patch_t, [3, num_patch_pixels, num_corres]);
clear patch_s patch_t;

Ak = zeros(3,3,num_corres);
for k = 1: num_corres
    Ak(:,:,k) = (patch_t3(:,:,k) * patch_s3(:,:,k)' + ...
        gamma*G) * pinv(patch_s3(:,:,k) * patch_s3(:,:,k)' + gamma * Id3);
end 
Ak = reshape(Ak, 9, []);

A = zeros(9,size(S.im,1), size(S.im,2));
for k = 1:(numel(Ak)/9)
    A(:,S.corres(k,1),S.corres(k,2)) = Ak(:,k);
end
A = reshape(A, 9, []);


function patches = get_corres_patch(patch_size, im, points)
% find the corresponding patch in image(S/T)

psize = (patch_size-1)/2;

% pad im with mirror reflections of itself
im = padarray(im, [psize psize], 'symmetric', 'both');

h = size(im,1);
w = size(im,2);

% the grid of a patch
[p_col, p_row] = meshgrid(-psize:psize, -psize:psize); 
nDim = numel(p_col);

grid_col = psize+1:w-psize;
grid_row = psize+1:h-psize;

% change corresponding points into image corrdinates (row & col)
grid_col = grid_col(points(:,2));
grid_row = grid_row(points(:,1));

npoints = numel(grid_col);

col = (repmat(p_col(:)',[npoints,1]) + repmat(grid_col(:),[1,nDim]))';
row = (repmat(p_row(:)',[npoints,1]) + repmat(grid_row(:),[1,nDim]))';

inds = sub2ind([h w],row(:), col(:));
im2 = reshape(im, [], 3);
patches = im2(inds,:)';
