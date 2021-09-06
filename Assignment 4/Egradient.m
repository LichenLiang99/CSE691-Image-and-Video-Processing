%calculate gradient and return 9x1 list of energy
%initialize maximum and minimum later used for normalization
function [Egrad] = Egradient(f,v)
    M=0;
    m=99999;
    
    %get neighborhood, its size, and gradient of the whole image
    Vineighbor = v;    
    Vinsize = size(Vineighbor,1);
    grad = edge(f).*imgradient(f,'sobel');
    
    %for each point in the neighborhood, find its gradient value, store it
    %then update max and min found.
    for i = 1:Vinsize
        tempgradient = grad(Vineighbor(i,2),Vineighbor(i,1));
        
        temp(i,:) = tempgradient;
        if tempgradient > M
            M = tempgradient;
        end
        if tempgradient < m
            m = tempgradient;
        end
    end

    %if the difference between max and min is less than 5, make min to be
    %max-5
    if M-m < 5
        m = M-5;
    end

    %normalize and return the gradient energy
    for j = 1:Vinsize
        Egrad(j,:) = (m-temp(j,1))./(M-m);
    end
end