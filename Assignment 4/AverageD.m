function[davg] = AverageD(PointsList)

dsum=0;
NoOfPoints = size(PointsList,1);
for i = 1:NoOfPoints-1
        dsum = dsum + pdist2(PointsList(i,:),PointsList(i+1,:),'euclidean');
end
davg = dsum./(NoOfPoints-1);
% disp(dsum);disp(NoOfPoints);
% disp(davg);
end