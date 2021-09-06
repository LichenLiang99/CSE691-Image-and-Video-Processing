%Canny Enhancer function
%find Es and Eo from image and set Eo to desired values
function[Es,Eo] = CannyEnhancer(f)
[M, N] = size(f);

%define filters
HorizontalFilter = [-1,0,1];
VerticalFilter = [-1; 0; 1];

%get Jx and Jy by convolution
Jx = conv2(f,HorizontalFilter,'same');
Jy = conv2(f,VerticalFilter,'same');

%get Es using the formula
Es = sqrt((Jx.^2)+(Jy.^2));

%get Eo by finding arctangent, the result is in radians
%so multiply by (180/pi) to get angle in degrees
Eo = zeros(M,N);
Eo = atan2(Jy,Jx);
Eo = Eo.*180/pi;

%if there are any angles that are negative, add 180 to it so it's positive
for i = 1:M
    for j = 1:N
        if Eo(i,j) < 0
            Eo(i,j) = Eo(i,j) + 180;
        end
    end
end

%change the angles to its nearest degrees.(ppt pg 19)
for i = 1 : M
    for j = 1 : N
        if ((Eo(i,j) > 0) && (Eo(i,j) < 22.5)) || ((Eo(i,j) > 157.5) && (Eo(i,j) < 180)) 
            Eo(i,j) = 0;
        elseif ((Eo(i,j) > 22.5) && (Eo(i,j) < 67.5) )
            Eo(i,j) = 45;
        elseif ((Eo(i,j) > 67.5) && (Eo(i,j) < 112.5))
            Eo(i,j) = 90;
        elseif ((Eo(i,j) > 112.5) && (Eo(i,j) < 157.5))
            Eo(i,j) = 135;
        end
    end
end
