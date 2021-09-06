%first, subtract the average face from X, then calculate XX' to be the covarient matrix.
%then calculate its eigenvectors Vcov, and eigenvalues Dcov.
%Dcov is a diagonal matrix, reform it in a list D.
%sort D from largest to smallest, and update their correspoinding
%eigenvectors by updating Vcov.
%Normalize the eigenvectors
%return the X with average subtracted, eigenvectors and eigenvalues.
function [tempX,Vcov,Dcov] = PCAA(X,colX,favg)
    for i = 1:colX
       tempX(:,i) = X(:,i) - favg; 
    end
    cov=X*X';
    
    [Vcov,Dcov] = eig(cov);
    D = diag(Dcov);
    [D,index]=sort(D,'descend');
    Vcov = Vcov(:,index);
    Vcov = normalize(Vcov,'norm');
    
end