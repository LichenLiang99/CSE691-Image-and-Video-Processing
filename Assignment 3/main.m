%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 3
%Lichen Liang

clearvars;clc;close all;

%read image, get their size, and display
f1=imread('CheckerBoard.jpg');
f1=f1(:,:,1);
% imtool(f1);
f2=imread('Building1.jpg');
f2=f2(:,:,1);
% imtool(f2);
f3=imread('check3.jpg');
f3=f3(:,:,1);
% imtool(f3);

%%filter image
out1gaus = imgaussfilt(f1,1);
out2gaus = imgaussfilt(f2,1);
out3gaus = imgaussfilt(f3,1);


%%get output, the parameters are (imput image, size), where size is NxN
%%neighborhood
%ONLY RUN ONE AT A TIME

out1 = C(out1gaus,5);
% out2 = C(out2gaus,5);
% outC = C(out3gaus,5);






