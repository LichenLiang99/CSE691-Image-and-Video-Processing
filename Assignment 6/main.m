%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 6
%Lichen Liang

clearvars;clc;close all;

%% Training
%define the number of frames, read, resize into a smaller size, then record
%its RBG values in 3 different matrices.
Nframes=5;
TrainingFolder = 'C:\Users\owner\Documents\MATLAB\CSE691\Assignment 6\Video1_1\Video1_1';
for i = 1:Nframes
    filename = strcat('PetsD2TeC1_',num2str(i),'.jpg');
    f = imread(fullfile(TrainingFolder,filename));
    f = imresize(f,0.8);
    f = im2double(f);
    Red(:,:,i) = f(:,:,1);
    Green(:,:,i) = f(:,:,2);
    Blue(:,:,i) = f(:,:,3);
end
[M,N,~]=size(f); 

%Calls the createcodebook function with parameters: number of rows, number
%of columns, number of frames, the 3 RBG matrices, alpha, beta, epsilon
tic
Codebook = createcodebook(M,N,Nframes, Red, Green, Blue,0.4,1.1,10);
toc

%calls the temporal filter function with parameters:number of rows, number
%of columns, number of frames, and the output from previous function
tic
FilteredCB = tfilter(M,N,Nframes,Codebook);
toc

%% Testing------------------------------------------------------------------

outputfolder1='C:\Users\owner\Documents\MATLAB\CSE691\Assignment 6\out1';
test1='C:\Users\owner\Documents\MATLAB\CSE691\Assignment 6\Video1_2';

%used for morphological operations
se=strel('cube',2);
se2=strel('cube',4);

%for each image in the testing folder(which I merged them all),
%read the images and resize it into the same size of the training set.
tic
counter=1;
for j = 750:2823
    filename2 = strcat('PetsD2TeC1_',num2str(j),'.jpg');
    f2 = imread(fullfile(test1,filename2));
    f2 = imresize(f2,0.8);
    f2 = im2double(f2);

    %calls background subtraction function with parameters: output from
    %temporal filter, number of rows, number of columns, alpha, beta,
    %epsilon,the test image
    out = BS(FilteredCB,M,N,0.4,1.1,10,f2);
    
    %erosion then dilation for morphological part,
    %comment out if not needed.
%     out = imerode(out,se);
%     out = imdilate(out,se2);

    %output to a folder
    filename3 = strcat('out',num2str(counter),'.jpg');
    full = fullfile(outputfolder1,filename3);
    imwrite(out,full);
    counter = counter + 1;
end
toc

%create video from the output folder 
video = VideoWriter('outftest1.avi'); 
open(video); 
for ii=1:2073 
  I = imread(fullfile(outputfolder1,strcat('out',num2str(ii),'.jpg'))); 
  writeVideo(video,I);
end
close(video);

