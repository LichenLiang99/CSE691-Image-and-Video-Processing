%calculate curvature and return 9x1 list of energy
%initialize maximum later used for normalization
function [Ecurv] = Ecurvature(PointsList, index, v, nop)
    cmax=0;
    
    %get the neighborhood, the previous point, and next point
    %if the current index is 1, then the last point is end-1
    %see report.
    Vineighbor = v;
    if index ~= 1
        Viprev = PointsList(index-1,:);
    else
        Viprev = PointsList(nop-1,:);

    end
    Vinext = PointsList(index+1,:);

    %get the size of neighborhood(either 9 or 25)
    Vinsize = size(Vineighbor,1);
    
    %get the curvature energy for each neighborhood value and store in a
    %temporary list, and get its maximum
    for i = 1:Vinsize
        tempc = (abs(Viprev-2.*Vineighbor(i,:)+Vinext));
        c = norm(tempc).^2;
        temp(i,:)=c;
        if c > cmax
            cmax = c;
        end
    end

    %Normalize and return the curvature energy
    for j = 1:Vinsize
        Ecurv(j,:) = temp(j,:)./cmax;
    end
              
end