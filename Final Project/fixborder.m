function[FinalOutput] = fixborder(image)

%define or initialize variables
[M,N,~]=size(image);
UpperBound= 99999;
LowerBound= 0;
LeftBound=99999;
RightBound=0;
HalfRow = round(M/2);
HalfCol = round(N/2);
counter= 0;

%change to gray if colored
if size(image,3)==3
    image=rgb2gray(image);
end

%number of iterations the fixing should run
iteration = 40;

%get the boundary/extreme values
for x = 1:M
    for y = 1:N
        if image(x,y) ~= 0 && y < LeftBound && y <= HalfCol
            LeftBound = y;
        end
        if image(x,y) ~= 0 && y > RightBound && y > HalfCol
            RightBound = y;
        end
        if image(x,y) ~= 0 && x > LowerBound && x > HalfRow
            LowerBound = x;
        end
        if image(x,y) ~= 0 && x<UpperBound && x <= HalfRow
            UpperBound = x;
        end
        if image(x,y) == 0
                counter = counter +1;
        end
    end
end

%calculate height and width, crop image
Vertical = LowerBound-UpperBound;
Horizontal = RightBound-LeftBound;
TargetSize = [Vertical Horizontal];
r = centerCropWindow2d(size(image),TargetSize);
new = imcrop(image,r);

%get the new pixel value for that pixel
[M2,N2]=size(new);
while iteration > 0
    for i = 2:M2-1
        for j = 2:N2-1
             if new(i,j) == 0
                 Y = [new(i-1,j-1:j+1);new(i,j-1:j+1);new(i+1,j-1:j+1)];
                 val = round(mean(mean(nonzeros(Y))));
                 new(i,j) = val;
                 if val ~= 0
                     counter = counter - 1;
                 end
             end
        end
    end
    iteration = iteration -1;
end

%crop again to remove black border
TargetSize2 = [M2-2, N2-2];
r2 = centerCropWindow2d(size(new),TargetSize2);
FinalOutput = imcrop(new,r2);


end