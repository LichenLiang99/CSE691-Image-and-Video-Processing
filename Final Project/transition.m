%do the transition, similar to OrderImages()
function [outTran] = transition(images)

%define parameters and variable
threshold = 10;
p = 0.99;
RANSACInlierRatio = 0.3;
e = 1.5; 

%get number of images
NumberOfImages = size(images, 4);

%initialize output after translation
outTran = zeros(3, 3, NumberOfImages);
outTran(:, :, 1) = eye(3);


[feature, descriptor] = getSIFT(images(:, :, :, 1), threshold);

%for each image, get SIFT feature and descriptor
%find their matched pair
%do RANSAC
for i = 2 : NumberOfImages
    ImageFeature = feature;
    ImageDescriptor = descriptor;
    
    [feature, descriptor] = getSIFT(images(:, :, :, i), threshold);
    [MatchPair] = getMatch(ImageFeature, ImageDescriptor, feature, descriptor);
    [outTran(:, :, i),~] = RANSAC(p, RANSACInlierRatio, 1, MatchPair, e);
end
end