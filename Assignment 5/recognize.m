%first, subtract the average face from test faces.
%get the new weight by multiplying the testface matrix and eigenface
%matrix.
%now we have two weights matrix, one with 20 columns and another with 145
%columns.
%for each column in the new weight(20 cols of test face), compare with each
%column old weight(145 cols of train face).
%Do this by subtracting one from another, and calculate the L2 norm of the
%result. Save the result in an results array. Then find the minimum. The
%index of the minimum will be the matched, and save this index number in
%the indexkeeper array, which is later returned.

function indexkeeper = recognize(Xtest, favgtest, colXtest, reducedV, weight, colX)
    for i = 1:colXtest
       tempXtest(:,i) = Xtest(:,i) - favgtest; 
    end
    
    newweight = tempXtest'*reducedV;
    newweight = newweight';
    weight = weight';
    
    for j = 1:colXtest %1-20
       currentcol = newweight(:,j);
       for k = 1:colX %1-145
            temp = currentcol - weight(:,k);
            result = norm(temp);
            resultarray(:,k) = result;
       end
       [~,index] = min(resultarray);
       indexkeeper(:,j) = index;
    end
    
end
