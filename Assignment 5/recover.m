%reconstruct the face by multiplying weight to the K eigenfaces
%then add the average back
%returns a recontructed version of X matrix.
function [out] = recover(weight,V,colX,favg)
    out = weight*V';
    out=out';
    for i = 1:colX
       out(:,i) = out(:,i) + favg; 
    end
end