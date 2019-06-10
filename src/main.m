%
% This code is part of the multi-view lighting transfer solution
% written by Qian Zhang (https://qianzhanginfo.github.io/)
% for the paper:
%
% @article{zhang2017lighting,
%   title={Lighting transfer across multiple views through local color transforms},
%   author={Zhang, Qian and Laffont, Pierre-Yves and Sim, Terence},
%   journal={Computational Visual Media},
%   volume={3},
%   number={4},
%   pages={315--324},
%   year={2017},
%   publisher={Springer}
% }
%
% Please cite properly if you used this code for research.
%

close all;
clear;

%% set method parameters
folder_name = 'demo_data';
index_source = '018';
index_target = '061';

image_width = 640;
% a 3-by-3 window for propagating transforms
propagation_window = 3; 


%% load the input data
% project 3D points to 2D image
S = load_data(folder_name, index_source, image_width);
T = load_data(folder_name, index_target, image_width);
imwrite(S.im, 'input_source.png');
imwrite(T.im, 'input_target.png');

% show overlay of correspondences on the images
imshow_corres(S, T);
disp(length(S.corres))

%% transfer lighting via local color transforms
% compute weights for propagation based on color differences
% the weight is an n-by-n matrix (n=S.imwidth*S.imheight)
W_nn = propagation_weights(S, propagation_window);

% compute local transforms using the correspondences
patch_size = 5;
A_k = transforms_compute(S, T, patch_size);

% propagate transforms
A_all = transforms_propagate(A_k, W_nn);

% apply transforms
output = transforms_apply(S, A_all);
figure('Name', 'output_ours'); imshow(output);
imwrite(output, 'output_ours.png');

%% comparison with baselines - warping, color propagation
%%{
% naive warping
warped_target = baseline_warp_target(S, T);
figure('Name', 'output_warped_target'); imshow(warped_target);
imwrite(warped_target, 'output_warped_target.png');

% naive color propagation
propageted_color = baseline_propagate_color(S, T, W_nn);
figure('Name', 'output_propogated_color'); imshow(propageted_color);
imwrite(propageted_color, 'output_propagated_color.png');
%}