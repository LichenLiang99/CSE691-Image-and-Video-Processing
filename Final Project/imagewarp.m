%return a warpped image
function [outImageWarp]=imagewarp(i,cf)

    %initialize
    outImageWarp=zeros(size(i),'like',i);
    
    %get number of layers
    if length(size(i))==2
        NumberOfLayers=1;
    else
        NumberOfLayers=size(i,3);
    end
    
    %for each layer
    for L = 1:NumberOfLayers
        
        %initialize size
        Y=size(i,1)/2;
        X=size(i,2)/2;
        y=(1:size(i,1))-Y;
        x=(1:size(i,2))-X;
        
        %calculate A and B
        [A,B]=meshgrid(x,y);
        B=cf*B./sqrt(A.^2+double(cf)^2)+Y;
        A=cf*atan(A/double(cf))+X;
        A=floor(A + 0.5);
        B=floor(B + 0.5);
        
        %get index
        Index=sub2ind([size(i,1),size(i,2)], B, A);
        
        %output the warpped imaged
        temp=zeros(size(i,1),size(i,2),'like',i);
        temp(Index)=i(:,:,L);

        outImageWarp(:,:,L)=temp;
    end
end