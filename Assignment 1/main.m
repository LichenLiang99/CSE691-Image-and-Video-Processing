%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 1
%Lichen Liang

clearvars;clc;

%read image, get their size, and display
f1=imread('NoisyImage1.jpg');
f1 = im2double(f1);
[M, N] = size(f1);
f2=imread('NoisyImage2.jpg');
f2 = im2double(f2);
[P, Q] = size(f2);
imtool(f1);
imtool(f2);

%part a) averaging filter -----------------------------------------------

%Define average filter of ones with size 3x3 and 5x5
%3x3 matrix is divided by 9 and 5x5 is divided by 25 
filter3x3 = (ones(3)/9);
filter5x5 = (ones(5)/25);

%filter the 2 images with 2 different filters and display
out1avg3 = conv2(f1,filter3x3,'same');
out1avg5 = conv2(f1,filter5x5,'same');
out2avg3 = conv2(f2,filter3x3,'same');
out2avg5 = conv2(f2,filter5x5,'same');
imtool(out1avg3);
imtool(out1avg5);
imtool(out2avg3);
imtool(out2avg5);


%part b)gaussian filter ---------------------------------------------

%calls the gaussian function with parameters(image,kernel size, sigma)
out1gaus31 = gaus(f1, 3, 1);
out1gaus33 = gaus(f1, 3, 3);
out1gaus53 = gaus(f1, 5, 3);
out1gaus38 = gaus(f1, 3, 8);

out2gaus31 = gaus(f2, 3, 1);
out2gaus33 = gaus(f2, 3, 3);
out2gaus53 = gaus(f2, 5, 3);
out2gaus38 = gaus(f2, 3, 8);

imtool(out1gaus31);
imtool(out1gaus33);
imtool(out1gaus53);
imtool(out1gaus38);

imtool(out2gaus31);
imtool(out2gaus33);
imtool(out2gaus53);
imtool(out2gaus38);


%part c) median filter ------------------------------------------------

%calls the median function with parameters(image, kernel size)
out1med3 = med(f1,3);
out1med5 = med(f1,5);
out2med3 = med(f2,3);
out2med5 = med(f2,5);
imtool(out1med3);
imtool(out1med5);
imtool(out2med3);
imtool(out2med5);





