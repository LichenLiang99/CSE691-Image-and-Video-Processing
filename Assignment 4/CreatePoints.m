%create points between the points clicked
%returns a new point list
function[PointsList] = CreatePoints(PointsClicked)


NoOfPoints=size(PointsClicked,1);
index=1;


for i = 1:NoOfPoints
    
    %if it's the last point, calculate its distance between the last and
    %the first
    if i == NoOfPoints
        d = pdist2(PointsClicked(i,:),PointsClicked(1,:),'euclidean');
        
        %if distance larger than 5, create points in between
        if d > 5
            PointsNeeded = floor(d./5);
            xl = linspace(PointsClicked(i,1),PointsClicked(1,1),PointsNeeded);
            xl = xl.';
            yl = linspace(PointsClicked(i,2),PointsClicked(1,2),PointsNeeded);
            yl = yl.';
            
            %created a new list for new points, get its size
            newL = [xl,yl];
            newL = floor(newL);
            NumberOfnewL = size(newL,1);
            
            %add the new list into the final Points List
            for j = 1:NumberOfnewL-1
                PointsList(index,:) = newL(j,:);
                index = index+1;
            end
            
            %add a copy of first entry to the end of the list
            PointsList(index,:) = PointsList(1,:);
        end
    
    %not the last point, same as above
    else
        d = pdist2(PointsClicked(i,:),PointsClicked(i+1,:),'euclidean');
        if d > 5
            PointsNeeded = floor(d./5);
            xl = linspace(PointsClicked(i,1),PointsClicked(i+1,1),PointsNeeded);
            xl = xl.';
            yl = linspace(PointsClicked(i,2),PointsClicked(i+1,2),PointsNeeded);
            yl = yl.';
            newL = [xl,yl];
            newL = floor(newL);
            NumberOfnewL = size(newL,1);
            for j = 1:NumberOfnewL-1
                PointsList(index,:) = newL(j,:);
                index = index+1;
            end
        end
    end
end

end