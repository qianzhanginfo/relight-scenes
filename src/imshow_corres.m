function imshow_corres(S, T)
% Overlay the correspondences on image.
% Preferred over the matlab built-in function scatter: the mark is exactly
% one pixel

overlay_source = S.im;
overlay_target = T.im;

red = zeros(1,1,3);
red(:,:,1) = 1;

for k = 1:length(S.corres)
    overlay_source(S.corres(k,1), S.corres(k,2), :) = red;
    overlay_target(T.corres(k,1), T.corres(k,2), :) = red;
end

figure('Name', 'inputs');
subplot(2,2,1); imshow(S.im); title('source')
subplot(2,2,2); imshow(T.im); title('target')
subplot(2,2,3); imshow(overlay_source); title('source correspondences')
subplot(2,2,4); imshow(overlay_target); title('target correspondences')