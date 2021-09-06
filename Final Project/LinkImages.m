%link images
function [outLink] = LinkImages(image, FinalTran, FinalH, FinalW, cf)

%get and initialize variables
image=im2double(image);
h = size(image, 1);
w = size(image, 2);
NumberOfChannels = size(image, 3);
NumberOfImages = size(image, 4);

%create a mask of size h*w
mask = ones(h, w);
mask = imagewarp(mask, cf);
mask = imcomplement(mask);
mask = bwdist(mask, 'euclidean');

%normalize
mask = mask ./ max(max(mask));

temp=ones([h,w,NumberOfChannels],'like',image);
for i=1:NumberOfChannels
    temp(:,:,i)=mask;
end
mask=temp;

%initialize max and min height and width
MaxH=0;
MinH=0;
MaxW=0;
MinW=0;

%update max and min height and width
for ii=1:NumberOfImages
    p=FinalTran(:,:,ii)*[1;1;1];
    p=p./p(3);
    BaseH=floor(p(1));
    BaseW=floor(p(2));

    if BaseH<MinH
        MinH=bash_h;
    end
    if BaseH>MaxH
        MaxH=BaseH;
    end
    if BaseW<MinW
        MinW=BaseW;
    end
    if BaseW>MaxW
        MaxW=BaseW;
    end

end

%create output pad
outLink = zeros([FinalH+30,FinalW+30,NumberOfChannels], 'like',image);
addMask = zeros([FinalH+30,FinalW+30,NumberOfChannels], 'like',image);


newMinH = MinH+10;
newMinW = MinW+10;
for i=1:NumberOfImages
    p=FinalTran(:,:,i)*[newMinH;newMinW;1];
    p=p./p(3);
    BaseH=floor(p(1));
    BaseW=floor(p(2));
    if BaseW==0
        BaseW=1;
    end
    if BaseH==0
        BaseH=1;
    end

    %update output
    outLink(BaseH:BaseH+h-1,BaseW:BaseW+w-1,:)=outLink(BaseH:BaseH+h-1,BaseW:BaseW+w-1,:)+image(:,:,:,i).*mask;
    addMask(BaseH:BaseH+h-1,BaseW:BaseW+w-1,:)=addMask(BaseH:BaseH+h-1,BaseW:BaseW+w-1,:) + mask;
end

%return
outLink=outLink./addMask;
end
