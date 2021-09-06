function [outPanorama] = createpanorama(image, cf)

NumberOfImages = size(image, 4);
WarppedImage = zeros(size(image), 'like', image);

%image warpped
for i = 1 : NumberOfImages
    WarppedImage(:, :, :, i) = imagewarp(image(:, :, :, i), cf);
end

%compute the transition of images using sift, matching and RANSAC
outTran = transition(WarppedImage);

%initialize final transition 
FinalTran = zeros(size(outTran));
FinalTran(:, :, 1) = outTran(:, :, 1);

%get final transition
for i = 2 : NumberOfImages
    FinalTran(:, :, i) = FinalTran(:, :, i - 1) * outTran(:, :, i);
end

%adjust the ends of images
h = size(WarppedImage, 1);
w = size(WarppedImage, 2);

%define variable
MaxHeight = h;
MinHeight = 1;
MaxWidth = w;
MinWidth = 1;

%compute maximum height and width
for i = 2 : NumberOfImages 
    MaxHeight = max(MaxHeight, FinalTran(1,3,i)+h);
    MaxWidth = max(MaxWidth, FinalTran(2,3,i)+w);
    MinHeight = min(MinHeight, FinalTran(1,3,i));
    MinWidth=min(MinWidth,FinalTran(2,3,i));
end

%calculate final height and weight
FinalH = ceil(MaxHeight) - floor(MinHeight) + 1;
FinalW = ceil(MaxWidth) - floor(MinWidth) +1;

FinalTran(2, 3, :) = FinalTran(2, 3, :) - floor(MinWidth);
FinalTran(1, 3, :) = FinalTran(1, 3, :) - floor(MinHeight);

%link and merge the images
outPanorama = LinkImages(WarppedImage, FinalTran, FinalH, FinalW, cf);

end

