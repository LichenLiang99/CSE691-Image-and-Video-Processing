%build a gaussian filter and apply to image
%get the input parameters, the coordinates, and plug into the 2d Gaussian
%filter formula. Then normalize it and convolve the kernel with the image

function[new]=gaus(f, filtsize, sigma)

s=filtsize;
sig=sigma;
[X,Y]=meshgrid(-s:s,-s:s);
G = exp(-(X.^2+Y.^2)/(2*sig.^2))/(2*pi*sig.^2);
G = G/sum(G(:));

new = conv2(f,G, 'same');



