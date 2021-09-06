%calculate the RANSAC and returns the transform with the max number of
%inliers found
function [Trans,MaxNumberOfInliers] = RANSAC(p, RANSACInlierRatio, NumberOfPairs, MatchPair, e)

%calculate number of iterations
NumberOfIterations = ceil(log(1 - p) / log(1 - RANSACInlierRatio^NumberOfPairs)); 

NumberOfPoints = size(MatchPair, 1);
MaxNumberOfInliers = 0;

temp1 = zeros(2*NumberOfPairs, 2);
temp2 = zeros(2*NumberOfPairs, 1);

%initialize temp1
for i = 1:NumberOfPairs
    temp1(2*i-1,1) = 1;
    temp1(2*i,2) = 1;
end

%for each iteration, get a random permuation of sample and calculate temp2
for i = 1:NumberOfIterations
    
    SamplingIndex = randperm(NumberOfPoints, NumberOfPairs);
    
    Sample = MatchPair(SamplingIndex,:,:);
    
    pair1 = Sample(:,:,1);
    pair2 = Sample(:,:,2);

    for j = 1:NumberOfPairs
        temp2(2*j-1) = pair1(j,1)-pair2(j,1);
        temp2(2*j) = pair1(j,2)-pair2(j,2);
    end
    
    
    t = temp1 \ temp2;
    Trans = [1 0 t(1); 0 1 t(2); 0 0 1];
    
    
    p2 = Trans * MatchPair(:,:,2)';
    error = MatchPair(:,:,1)' - p2;
    SquareError = error .^ 2;
    SumOfSquareError = sum(SquareError);
    
    NumberOfInliers=sum(SumOfSquareError < e);
    
    %find the set with most number of inliers
    if NumberOfInliers > MaxNumberOfInliers
        Set = find(SumOfSquareError < e);
        MaxNumberOfInliers = NumberOfInliers;
    end
end

%recompute transform using inliers
pair1 = MatchPair(Set,:,1);
pair2 = MatchPair(Set,:,2);

for j = 1:NumberOfPairs
    temp2(2*j-1) = pair1(j,1)-pair2(j,1);
    temp2(2*j) = pair1(j,2)-pair2(j,2);
end
t = temp1 \ temp2;
Trans = [1 0 t(1); 0 1 t(2); 0 0 1];

end