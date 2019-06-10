function propageted_color = baseline_propagate_color(S, T, W_nn)
% naive baseline: propagate color based on weights (instead of transforms)

height_s = size(S.im,1); width_s = size(S.im,2);
height_t = size(T.im,1); width_t = size(T.im,2);
num_pixels_s = height_s * width_s;

corres_color = zeros(num_pixels_s, 3);
propageted_color = zeros(num_pixels_s, 3);
color_t = reshape(T.im, [], 3);

corres_index_s = sub2ind([height_s, width_s], S.corres(:,1), S.corres(:,2));
corres_index_t = sub2ind([height_t, width_t], T.corres(:,1), T.corres(:,2));
corres_color(corres_index_s, :) = color_t(corres_index_t, :);

for i=1:3
    propageted_color(:, i)= W_nn \ corres_color(:,i);   % left divide
end

propageted_color = reshape(propageted_color, height_s, width_s, 3);
