%get sift features using the library function vl_sift
function [feature, descriptor] = getSIFT(image, threshold)

%change to gray scale if in RGB
if (size(image, 3) == 3)
    temp = single(rgb2gray(image));
else
    temp = single(image);
end

% get features and descriptors
[feature, descriptor] = vl_sift(temp, 'EdgeThresh', threshold);

end 