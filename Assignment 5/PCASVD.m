%subtract the average. 
%calculate the covarience matrix Y.
%use the svd() function to do singular value decomposition. This decomposes
%Y into 3 matrices, we need the eigenvalues S and eigenvectors V.
%similar to part 1, reform S into a list, sort by descending and its
%eigenvectors, then normalize.
function [tempX,V,S] = PCASVD(X,colX,favg)
    for i = 1:colX
       tempX(:,i) = X(:,i) - favg; 
    end
    Y = (tempX')/sqrt(colX-1);
    
    [~,S,V] = svd(Y);
    S = diag(S);
    [S,index]=sort(S,'descend');
    V = V(:,index);
    V = normalize(V,'norm');


end