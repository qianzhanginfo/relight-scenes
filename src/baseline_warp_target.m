function warped_target = baseline_warp_target(S, T)
% naive baseline: wapring

%% compute homography
% backward warping: image1 to image2
% homography: [u v 1]' = HOMO_33 * [x y 1]'
% a system of linear equations: A*h = b, where
% h = [a,b,c,d,e,f,g,h]T;
% overconstrained, solve using least-squres
ncorres = length(S.corres);
x = S.corres(:,1); y = S.corres(:,2);
u = T.corres(:,1); v = T.corres(:,2);

A = [x, y, ones(ncorres, 1), zeros(ncorres, 3), -u.*x, -u.*y; ...
    zeros(ncorres, 3), x, y, ones(ncorres, 1), -v.*x, -v.*y];
b = [u; v];

h = [mldivide(A, b); 1];
h = reshape(h, 3, 3);
homography_backward = h'; % transpose

%% apply homographic transformations
% warp target image to source

% calculate coordinates in target via backward homography transformation
height_t = size(T.im, 1); width_t = size(T.im, 2);
height_s = size(S.im, 1); width_s = size(S.im, 2);

coords_s_x = repmat([1: height_s]', [1, width_s]);
coords_s_y = repmat([1: width_s], [height_s, 1]);
coords_s = [coords_s_x(:), coords_s_y(:)]';

coords_t_homo = homography_backward * [coords_s; ones(1, height_s*width_s)];
coords_t = coords_t_homo(1:2, :) ./ coords_t_homo(3,:);

% get color for warped target
warped_target = zeros(height_s*width_s, 3);
color_t = reshape(T.im, [],3);

u0 = floor(coords_t(1,:)');
v0 = floor(coords_t(2,:)');
uniu = coords_t(1,:)' - u0;
univ = coords_t(2,:)' - v0;

% remove pixels out of source image boundary
outlier_index = u0<1 | (u0+1)>height_t | v0<1 | (v0+1)>width_t;
u0(outlier_index) = [];
v0(outlier_index) = [];
uniu(outlier_index) = [];
univ(outlier_index) = [];

% bilinear interpolation
color_00 = color_t(sub2ind([height_t, width_t], u0, v0), :);
color_10 = color_t(sub2ind([height_t, width_t], u0+1, v0), :);
color_01 = color_t(sub2ind([height_t, width_t], u0, v0+1), :);
color_11 = color_t(sub2ind([height_t, width_t], u0+1, v0+1), :);

color_u0 = color_00 + uniu.*(color_10-color_00);
color_u1 = color_01 + uniu.*(color_11-color_01);
color_uv = color_u0 + univ.*(color_u1-color_u0);

warped_target(~outlier_index, :) = color_uv;
warped_target = reshape(warped_target, height_s, width_s, 3);

