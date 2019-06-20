function points = load_3d_points(folder_name, index_source, index_target)
% load 3D points visible from both images in the reconstructed point cloud

mode = 'demo';

switch mode
    % for the demo
    case 'demo'
        load(fullfile(folder_name, 'demo_points.mat'), 'points');
        
    % to use pmvs/cmvs .patch file
    case 'pmvs'
        filepath = fullfile(folder_name, 'models', 'option-custom.patch');
        numim = 118;

        % read raw data or load processed mat file
        data = read_pmvs_data(filepath, numim);
%         load([replace(filepath, '/models', '') '.mat'], 'data')
        roiIDX = full(data.idx);

        idS = str2double(index_source) + 1; % pmvs image named from 0
        idT = str2double(index_target) + 1;
        points = data.points(roiIDX(:,idS) + roiIDX(:,idT) == 2, :);
        
end
