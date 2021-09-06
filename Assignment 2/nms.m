%Non-maximum suppression function
%get Eo for each Es, if value of Es is less than its neighbors along the Eo
%angle, then output In of that location set to 0, otherwise set In of that
%location to Es of that location
%In is the output of this function

function[In] = nms(Es,Eo)
[M, N] = size(Es);

%initialize with zeros
In = zeros(M,N);

%Ignoring the borders because some neighbors are missing
for i = 2 : M-1
    for j = 2 : N-1
        
        %%yellow region, 0 degrees-----------------------
        if Eo(i,j) == 0
            
            %if current value is less than its right or its left value
            %set In to zero
            if ((Es(i,j) < Es(i,j-1)) || (Es(i,j) < Es(i,j+1)))
                In(i,j) = 0;
            else
                In(i,j) = Es(i,j);
            end
        end
        
        %%green region, 45drgrees-----------------------
        if Eo(i,j) == 45

            %if current value is less than its bottom left or top right value
            if ((Es(i,j) < Es(i+1,j-1)) || (Es(i,j) < Es(i-1,j+1)))
                In(i,j) = 0;
            else
                In(i,j) = Es(i,j);
            end
        end
        
        %%blue region, 90degrees-----------------------
        if Eo(i,j) == 90
                 
            %if current value is less than its top or bottom value
            if ((Es(i,j) < Es(i-1,j)) || (Es(i,j) < Es(i-1,j)))
                In(i,j) = 0;
            else
                In(i,j) = Es(i,j);
            end
        end
        
        %%red region, 135 degrees-------------------
        if Eo(i,j) == 135
            
            %if current value is less than its bottom right or top left
            if ((Es(i,j) < Es(i-1,j-1)) || (Es(i,j) < Es(i+1,j+1)))
                In(i,j) = 0;
            else
                In(i,j) = Es(i,j);
            end
        end
    end
end
