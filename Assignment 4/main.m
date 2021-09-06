%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 4
%Lichen Liang

clearvars;clc;close all;

%read image, filter with gaussian, show images and click the points to
%create a PointsClicked array
f1=imread('image1.jpg');
f1=f1(:,:,1);
f1=imgaussfilt(f1,1);
imshow(f1);
hold on;
[x,y] = getpts;
PointsClicked = [x,y];
hold off;

% Create extra points
initialPointsList = CreatePoints(PointsClicked);

%calculate fraction, and call greedy algorithm
%the parameters for Greedy function: image, points list, neighborhood size,
%and fraction
frac = round(0.1.*size(initialPointsList,1));
[out1,int1,int2] = Greedy(f1,initialPointsList,3,frac);




%%plot the final points onto the image
R = size(initialPointsList,1);
imshow(f1);
hold on;
for ii=1:R
        plot(initialPointsList(ii,1),initialPointsList(ii,2),'g.');
        plot(int1(ii,1),int1(ii,2),'y.');
        plot(int2(ii,1),int2(ii,2),'b.');
        plot(out1(ii,1),out1(ii,2),'r.');
end
hold off;

%%-------------------------------------------------------------------




