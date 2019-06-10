function W = propagation_weights(S, propagation_window)
% return an n-by-n matrix (n=S.imwidth*S.imheight)sparse matrix

wd=(propagation_window-1)/2; %wd=1, window size=3*3
im=S.im;

h=size(im,1); w=size(im,2);
img_size=h*w;

mask = zeros(h, w);
pointsM = sub2ind([h, w], S.corres(:,1), S.corres(:,2));
mask(pointsM) = 1; % withcorres = 1
mask = logical(mask);

indsM=reshape(1:img_size,h,w); % index map

len=0; % the sampled pixel length
consts_len=0; % the image pixel length
col_inds=zeros(img_size*propagation_window^2,1); 
row_inds=zeros(img_size*propagation_window^2,1); 
vals=zeros(img_size*propagation_window^2,1); % propagation weight based on pixel intensities
rgbvals=zeros(propagation_window^2, 3); % intensity value in the window
wvals = zeros(propagation_window^2, 1); % weight value for sampled pixels in the window

% This for loop calculates the weights for each pixel in each sampling
% window, based on gray intensities.

for j=1:w
   for i=1:h % along column (downward)
      consts_len=consts_len+1; 
      
      if (~mask(i,j))   % for pixels without correspondences
        tlen=0; % local index (length of values in vector)
        for ii=max(1,i-wd):min(i+wd,h) % subscript cannot exceed the image (for pixels at boundary)
           for jj=max(1,j-wd):min(j+wd,w)
            
              if (ii~=i) || (jj~=j) % exclude the center pixel
                 len=len+1; tlen=tlen+1;
                 row_inds(len)= consts_len; % window index for each sampled pixel
                 col_inds(len)=indsM(ii,jj); % pixel index in image for each sampled pixel
                 rgbvals(tlen,:)=im(ii,jj,:); % value equals to the gray intensity of pixels in the same location
              end
           end
        end
        t_val=reshape(im(i,j,:), 1,3); % center pixel value
        rgbvals(tlen+1,:)=t_val; % the last value in the vector(gvals) is the center pixel value.
        c_dis2 = sum(bsxfun(@minus, rgbvals(1:tlen+1, :),  mean(rgbvals(1:tlen+1,:))).^2, 2);
        csig = mean(c_dis2)*0.6; % for better results, from [Levin04] code
        mcd = min(c_dis2); % min of squared color distances
        if (csig<(-mcd/log(0.01)))
            csig=-mcd/log(0.01);
        end
        if (csig<0.000002)
            csig=0.000002;
        end

        wvals(1:tlen)=exp(-sum(bsxfun(@minus, rgbvals(1:tlen, :), t_val).^2,2)/csig); % Gaussian sampling (equation 2 in the paper)
        wvals(1:tlen)=wvals(1:tlen)/sum(wvals(1:tlen)); % normalization
        vals(len-tlen+1:len)=-wvals(1:tlen);
      end

      % values for the center pixel  
      len=len+1;
      row_inds(len)= consts_len;
      col_inds(len)=indsM(i,j);
      vals(len)=1;

   end
end

% eliminate unused elements       
vals=vals(1:len);
col_inds=col_inds(1:len);
row_inds=row_inds(1:len);


W=sparse(row_inds,col_inds,vals,consts_len,img_size);