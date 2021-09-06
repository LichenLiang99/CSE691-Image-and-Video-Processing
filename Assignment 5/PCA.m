%subtract the average. 
%calculate the covarience matrix = X'X.
%find the eigenvectors and eigen values, then sort the eigenvalue,
%normalize

function [tempX,V3,D] = PCA(X,colX,favg)
    for i = 1:colX
       tempX(:,i) = X(:,i) - favg; 
    end
    CovMat = tempX' * tempX;
    [V3,D] = eig(CovMat);
    
    %sort eigenvalue
    D=diag(D);
    [D,index]=sort(D,'descend');
    V3=V3(:,index);
    V3 = tempX*V3;
    V3 = normalize(V3,'norm');

end