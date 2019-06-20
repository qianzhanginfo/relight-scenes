function data = read_pmvs_data(filepath, numim)
% read data from patch file and save in a sparse matrix.
% only good visible points are imported. excluding the points #should# be
% visible.
% REF: https://www.di.ens.fr/pmvs/documentation.html

% .patch file format:
%{
S.patch contains full reconstruction information. 

line 1: a header "PATCHES" 
line 2: the number N of reconstructed 3D oriented points. 

line 3: 3D location of point, in homogeneous coordinates.
lint 4: the estimated surface normal, in homogeneous coordinates.

line 5: three numbers. 
	The first number is the photometric consistency score associated with 
        the point, which is the average normalized cross correlation score 
        ranging from -1.0 (worse) to 1.0 (good).
	The remaining two numbers are for debugging purposes.

line 6: the number of images in which the point is visible and textures 
    agree well.
line 7: actual image indexes.

line 8: the number of images in which textures may not agree well but the 
    point should be visible from visibility analysis
line 9: the actual image indexes. 

Refer to the pmvs papers for more detailed expalantions of these two different 
types of visible images.
%}

fp = fopen(filepath);
fgetl(fp); % file header "PATCHES"

npoints =  sscanf(fgetl(fp),'%d'); % number of 3D points
points = zeros(npoints, 4);
idx = zeros(npoints, numim);
for k = 1:npoints
    fgetl(fp); % header "PATCHS"
    l = strsplit(fgetl(fp));
    points(k,:) = str2double(l); % 3D homo points
    fgetl(fp); % surface normal
    fgetl(fp); % three numbers
    
    fgetl(fp); % nunber of images that agree well
    idx1 = strsplit(deblank(fgetl(fp)));
    idx1 = str2double(idx1);
    ind = zeros(1, length(idx1));
    for j = 1:length(idx1)
        ind(j) = find(index == idx1(j));
    end
    idx(k,ind) = 1;
    
    % discard
    fgetl(fp); % number of images that don't agree well
    fgetl(fp); % image indices
    fgetl(fp);
        
end

idx = sparse(idx);
fclose(fp);

data.points = points;
data.idx = idx;

save([replace(filepath, '/models', '') '.mat'], 'data');
