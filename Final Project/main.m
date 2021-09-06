%%%%%%%%%%%%%%%%%%%%CSE 691 Final Project, Lichen Liang%%%%%%%%%%%%%

clear all;clc;
% close all;
%get panorama for all test sets
NumberOfSets = 11;
for i=1:NumberOfSets
    Final=getpanorama(i);
    figure
    imshow(Final);
end

function [FinalOutput]=getpanorama(FileNumber)
    
    %change test data here
    ImageFolder={'goldengate','office','yosmite','rio','halfdome','yard','diamondhead','fishbowl','hotel','grandcanyon','carmel'};
    filename=FileNumber;
    path='images';

    %define parameters
    CameraFocus=[2000,3000,1000,3000,2000,4000,1000,2000,1000,1000,1000];
    ImageMaxSize = 500;
    
    cf = CameraFocus(filename);

    set = imageSet(fullfile(path,ImageFolder{filename}));

    %read the first image in the set and its 1st dimension size
    First=read(set,1);
    
    FirstImageSize=size(First,1);
    
    %if it is larger than the max size we set, resize it
    if FirstImageSize>ImageMaxSize
        First=imresize(First,ImageMaxSize/FirstImageSize);
    end
    
    %create 0s of the same dimension as the first image
    %then resize all other images if they are larger than the max size
    Others = zeros(size(First,1),size(First,2),size(First,3),set.Count,'like',First);
    for ii=1:set.Count
        temp=read(set,ii);
        if FirstImageSize>ImageMaxSize
            Others(:,:,:,ii)=imresize(temp,ImageMaxSize/FirstImageSize);
        else
            Others(:,:,:,ii)=temp;
        end
    end

    %call createpanorama, returns a panorama image
    output=createpanorama(Others, cf);
    output = im2uint8(output);
    
    imtool(output);
    %fix the border issue
    FinalOutput = fixborder(output);
%     imtool(FinalOutput);
    
end