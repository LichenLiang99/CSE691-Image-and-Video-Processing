%get the top K eigenvectors(reducedV), then multiply by the Xtest with subtracted
%average.
function [weight,reducedV] = getweight(tempX,V,K)
    reducedV = V(:,1:K);
    weight = tempX'* reducedV;
end