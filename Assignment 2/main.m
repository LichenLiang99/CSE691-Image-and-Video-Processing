%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 2
%Lichen Liang

clearvars;clc;close all;

%read image, get their size, and display
f1=imread('Flowers.jpg');
[M, N] = size(f1);
f2=imread('Syracuse_01.jpg');
f2 = double(f2);
[P, Q] = size(f2);
f3=imread('Syracuse_02.jpg');
[R, S] = size(f3);
% imtool(f1);
% imtool(f2);
% imtool(f3);

%----part 1a-------------------------------------------------
%filter the image
out1gaus = imgaussfilt(f1,1);
out2gaus = imgaussfilt(f2,1);
out3gaus = imgaussfilt(f3,1);

%get two outputs from canny enhancer, Edge strength Es and 
%Orientation of Edge normal Eo,
%with input the filtered image
[out1Es,out1Eo] = CannyEnhancer(out1gaus);
[out2Es,out2Eo] = CannyEnhancer(out2gaus);
[out3Es,out3Eo] = CannyEnhancer(out3gaus);

% imtool(out1Es);
% imtool(out2Es);
% imtool(out3Es);


%----part 1b-------------------------------------------------
%use the output from canny enhancer, do non-max suppression
%parameter: matrix Es, matrix Eo
out1In = nms(out1Es,out1Eo);
out2In = nms(out2Es,out2Eo);
out3In = nms(out3Es,out3Eo);

imtool(out1In);
imtool(out2In);
imtool(out3In);

%-----part 1c-------------------------------------------------
%use output from canny enhancer and non-max supression, get the final
%output.
%the parameters are (matrix In, matrix Eo,High threshold, Low threshold)
out1HT = HThreash(out1In,out1Eo,60,20);
out2HT = HThreash(out2In,out2Eo,50,30);
out3HT = HThreash(out3In,out3Eo,30,20);

imtool(out1HT);
imtool(out2HT);
imtool(out3HT);

%-----part 3-----------------------------
%pick an image of mine
f4=imread('NYC.jpg');
f4=f4(:,:,1);
[U, V] = size(f4);

outNYCgaus = imgaussfilt(f4,1);
[outNYCEs,outNYCEo] = CannyEnhancer(outNYCgaus);
outNYCIn = nms(outNYCEs,outNYCEo);
outNYCHT = HThreash(outNYCIn,outNYCEo,40,20);
imtool(outNYCIn);
imtool(outNYCHT);

%reverse the image
for i = 1:U
    for j = 1:V
        if outNYCHT(i,j) == 255
            outNYCHT(i,j) = 0;
        elseif outNYCHT(i,j) == 0
            outNYCHT(i,j) = 255;
        end
    end
end
imtool(outNYCHT);




