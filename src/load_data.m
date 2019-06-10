function img_object = load_data(folder_name, image_index, image_width)

%% load the input data
% 3D points visible from both images in the reconstructed point cloud
load(fullfile(folder_name,'demo_points.mat'),'points');

% image
image = imread(fullfile(folder_name, ['00000' image_index '.jpg']));
image_scale = image_width/max(size(image));
image = imresize(image, image_scale);
image = im2double(image);

% estimated camera matrix
projection_matrix = zeros(3,4);

txt = fopen(fullfile(folder_name, ['00000' image_index '.txt']));
fgetl(txt); % file header "CONTOUR"
for k = 1:3
    l = deblank(fgetl(txt));
    l = strsplit(l);
    projection_matrix(k,:) = str2double(l);       
end
fclose(txt);

%% project the 3D points to the image plane
% homogeneous coordinates
homo_coords = (projection_matrix * points')';

% correspondences in the image plane
corres = zeros(length(homo_coords), 2);

corres(:,2) = homo_coords(:,1) ./ homo_coords(:,3);
corres(:,1) = homo_coords(:,2) ./ homo_coords(:,3);
corres = (corres + 1) * image_scale;
corres = round(corres);

% set the pixel coordinates limit
% because we use a 3-by-3 window for propagating local transforms
corres(corres < 2) = 2;
corres(corres(:,1) > (size(image,1) - 2), 1) = size(image,1) - 2;
corres(corres(:,2) > (size(image,2) - 2), 2) = size(image,2) - 2;

img_object.im = image;
img_object.corres = corres;


