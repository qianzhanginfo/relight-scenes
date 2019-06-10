function output = transforms_apply(S, A)

dim = size(S.im);
output = zeros(dim(1)*dim(2), 3);

im = reshape(S.im,[],3);

for k = 1:size(im,1)
    output(k,:) = (A(:,:,k) * im(k,:)')';
end

output = reshape(output, dim(1), dim(2), 3);
