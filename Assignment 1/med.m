%Build median filter and apply to image
%Get input parameters. Create a zero padded image of the same size as
%original image. The offset determines the starting point of the
%processing. i.e. a kernel size of 3x3 will have offset=1, so that 
%processing starts at (2,2) instead of (1,1).
%Create the matrix at that pixel location, reshape it into 1D array, sort
%it, then find its median and set it to that pixel location.

function[new] = med(f, filtsize)

[M,N] = size(f);
out = zeros(M,N);
offset = floor(filtsize/2);

for x = 1 + offset : (M-offset)
    for y = 1 + offset : (N-offset)
        matrx = f(x-offset:x+offset,y-offset:y+offset);
        matrx2 = reshape(matrx,[1,filtsize.^2]);
        matrx3 = sort(matrx2);
        out(x,y) = matrx3(1,ceil(filtsize.^2/2));
    end
end
new = double(out);