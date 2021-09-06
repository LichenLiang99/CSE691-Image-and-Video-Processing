%calculate and return a 9x1 list of energy
%first initialize max distance to be 0
function [Econt] = Econtinuity(PointsList, index, davg, v, nop)
    dmax=0;

    %get neighborhood and the previous point
    %if the current index is 1, then the last point is end-1
    %see report.
    Vineighbor = v;
    if index ~= 1
        Viprev = PointsList(index-1,:);
    else
        Viprev = PointsList(nop-1,:);

    end
    
    %get the size of neighborhood(either 9 or 25)
    Vinsize = size(Vineighbor,1);
    
    %for each entry in neighborhood, calculate the distance between current
    %point in neighborhood and previous point Viprev
    %save to a temporary list
    %also find the maximum distance
    for i = 1:Vinsize
        d = pdist2(Viprev,Vineighbor(i,:),'euclidean');
        temp(i,:)=d;
        if d > dmax
            dmax = d;
        end
    end

    %for each entry in temporary list, normalize and use the formula to 
    %find its energy
    for j = 1:Vinsize
        Econt(j,:) = (davg-temp(j,:))./dmax;
    end
              
end