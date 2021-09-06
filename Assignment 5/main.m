%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CSE691 Assign 5
%Lichen Liang

clearvars;clc;close all;
%% initializing and average face
%read 145 training images into the matrix X, with each column representing a
%face. I have also resized the face to 50% of the original size for faster
%execution.
%steps: read image, resize to 50%, calculate number of rows(product of
%dimensions),add to X matrix as a column.
facefolder = 'C:\Users\owner\Documents\MATLAB\CSE691\Assignment 5\faces';
for i = 1:145
    filename = strcat('train',num2str(i),'.jpg');
    f = imread(fullfile(facefolder,filename));
    f = imresize(f,0.5);
    [M,N] = size(f);
    row = M.*N;
    f = reshape(f,[row 1]);
    X(:,i) = f;
end
X=double(X);

%get the average face for display, and the average face before reshaping
[averageface,favg] = AverageFace(X,M,N);
% imtool(averageface);
averageface = double(averageface);

%get size of X
[rowX,colX] = size(X);

%% part 1, Using XX'------------------------
%calls the PCAA function with parameters: X, number of columns(faces, in
%this case 145), and average face as a column.
tic
[tempX1,Vcov,Dcov] = PCAA(X,colX,favg);
toc

%% part 2, Using SVD------------------------
% %parameters and output similar to part 1, uses a different method.
tic
[tempX2,V,S] = PCASVD(X,colX,favg);
toc

%% part 3, Using X'X------------------------
%parameters and output similar to part 1, uses a different method.
tic
[tempX3,V2,D2] = PCA(X,colX,favg);
toc

%% Define K and display original images for comparison
%K is number of eigenfaces we want to use, it varies as we test it
K=40; 

%display original 20 images
figure;
for original = 1:20 
    o1 = reshape(uint8(X(:,original)), M, N);
    subplot(4,5,original),imshow(o1);
end
sgtitle('first 20 original faces');

%% read test images
%read the 20 test images, resize, reshape and then form Xtest 
testfolder = 'C:\Users\owner\Documents\MATLAB\CSE691\Assignment 5\test';
for j = 1:20
    filename = strcat('test',num2str(j),'.jpg');
    ftest = imread(fullfile(testfolder,filename));
    ftest = imresize(ftest,0.5);
    [O,P] = size(ftest);
    row2 = O.*P;
    ftest = reshape(ftest,[row2 1]);
    Xtest(:,j) = ftest;
end
Xtest=double(Xtest);
[rowXtest,colXtest] = size(Xtest);

%get the average face for the test images
[~,favgtest] = AverageFace(Xtest,O,P);

%subtract the average face of test images
for t = 1:colXtest
       tempXtest(:,t) =Xtest(:,t) - favgtest; 
end

% display the test images
figure;
for imgindex = 1:colXtest 
    f5 = reshape(uint8(Xtest(:,imgindex)), O, P);
    subplot(4,5,imgindex),imshow(f5);
end
sgtitle('20 Test Images');

%% get weight, reconstruct, and display from PART 3
%calculates the weight from top K eigenfaces
%parameters: Xtest with average subtracted, eigenvectors from PCA, and K
%outputs the weight matrix and K eigenvectors only.
[weight,reducedV] = getweight(tempXtest,V2,K);

%reconstruct the faces using the weights and the K eigenfaces.
%parameters:weight and K eigenvectors calculated from getweight(), 
%number of columns(images) in X matrix, and average face
recover1 = recover(weight,reducedV,colXtest,favgtest);

% %display the reconstructed faces from part 3
figure;
for recon1 = 1:20 
    r1 = reshape(uint8(recover1(:,recon1)), M, N);
    subplot(4,5,recon1),imshow(r1);
end
sgtitle('Part 3 reconstructed');




%% get weight, reconstruct, and display from PART 2

%project and recon for PCASVD
[weight2,reducedV2] = getweight(tempXtest,V,K);
recover2 = recover(weight2,reducedV2,colXtest,favgtest);

% display the reconstructed faces from part 2
figure;
for recon2 = 1:20 
    r2 = reshape(uint8(recover2(:,recon2)), M, N);
    subplot(4,5,recon2),imshow(r2);
end
sgtitle('Part 2 reconstructed');

%% get weight, reconstruct, and display from PART 1

%project and recon for PCAA
[weight3,reducedV3] = getweight(tempXtest,Vcov,K);
recover3 = recover(weight3,reducedV3,colXtest,favgtest);

%display the reconstructed faces from part 1
figure; 
for recon3 = 1:20 
    r3 = reshape(uint8(recover3(:,recon3)), M, N);
    subplot(4,5,recon3),imshow(r3);
end
sgtitle('Part 1 reconstructed');

%% recognition

%get weight for the training images
[weight4,reducedV4] = getweight(tempX3,V2,K);

%recognize the images too see if there are any matches to the training
%images. The output is an array of indexes of the original matrix X that is
%a match. For example, first image in the test image Xtest has an index of 1, it
%is matched to the 5th images in original matrix X, then this array at
%index position 1 has the value of 5.
%parameters: test image matrix, average face of the test images, number of
%testing images, K eigenfaces, its weight, number of training images
indexkeeper = recognize(Xtest, favgtest, colXtest, reducedV, weight4, colX);



% %display the matched images
figure;
for imgindex2 = 1:colXtest
    f6 = reshape(uint8(X(:,indexkeeper(:,imgindex2))), O, P);
    subplot(4,5,imgindex2),imshow(f6);
end
sgtitle('Its matched 20 training images');

%----------------------------------------------------------------------------------
%% non face images
%read the 20 non face images, get its matrix and its average
nonfacefolder = 'C:\Users\owner\Documents\MATLAB\CSE691\Assignment 5\NonfaceImages';
for k = 1:20
    filename = strcat('NonFace',num2str(k),'.jpg');
    ftest2 = imread(fullfile(nonfacefolder,filename));
    ftest2 = imresize(ftest2,[77,58]);
    ftest2 = rgb2gray(ftest2);
    [Q,R] = size(ftest2);
    row3 = Q.*R;
    ftest2 = reshape(ftest2,[row3 1]);
    Xtest2(:,k) = ftest2;
end
Xtest2=double(Xtest2);
[rowXtest2,colXtest2] = size(Xtest2);
[~,favgtest2] = AverageFace(Xtest2,Q,R);

for t2 = 1:colXtest2
       tempXtest2(:,t) =Xtest2(:,t2) - favgtest2; 
end

% %display non face images 
figure;
for jj=1:20
    f8 = reshape(uint8(Xtest2(:,jj)), Q, R);
    subplot(4,5,jj),imshow(f8);
end
sgtitle('original non-face');

%reconstruct 
[weight5,reducedV] = getweight(tempXtest2,V2,K);
recover4 = recover(weight5,reducedV,colXtest2,favgtest2);

%display reconstructed
figure;
for ii=1:20
    f7 = reshape(uint8(recover4(:,ii)), Q, R);
    subplot(4,5,ii),imshow(f7);
end
sgtitle('recovered non-face');

%% Frobinius norm
%calculate and display difference
for kk = 1:20
   diff(:,kk) = abs(Xtest2(:,kk) - recover4(:,kk)); 
end
figure;
for kkk=1:20
    f8 = reshape(uint8(diff(:,kkk)), Q, R);
    subplot(4,5,kkk),imshow(f8);
end
sgtitle('difference for non-face images');

%calculate Frobenius norm and plot
for ff=1:20
    fnorm(:,ff) = norm(diff(:,ff),'fro');
end

figure;
plot(fnorm);

%calculate difference for face
for xx = 1:20
   diff2(:,xx) = abs(Xtest(:,xx) - recover1(:,xx)); 
end

%display
figure;
for xxx=1:20
    f10 = reshape(uint8(diff2(:,xxx)), M, N);
    subplot(4,5,xxx),imshow(f10);
end
sgtitle('difference for face images');

%calculate Frobenius norm and plot
for fff=1:20
    fnorm2(:,fff) = norm(diff2(:,fff),'fro');
end
figure;
plot(fnorm2);