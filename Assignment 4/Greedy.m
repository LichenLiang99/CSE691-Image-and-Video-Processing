%implements greedy snake function discussed in class
function[out,int1,int2] = Greedy(f,PointsList,s,frac)

% set variables
%beta change is the array contains all indexes of points that are needed to
%be relaxed in case of a corner
alpha=1;beta=1;gamma=1;
iteration = 1;
betachange = [];

%size of the points list
NoOfPoints = size(PointsList,1);

%calculate the gradient of the image and set the second threshold to be 
%30% of the maximum gradient value
HorizontalFilter = [-1,0,1];
VerticalFilter = [-1; 0; 1];
Jx = conv2(f,HorizontalFilter,'same');
Jy = conv2(f,VerticalFilter,'same');
grad = sqrt((Jx.^2)+(Jy.^2));
thresh2 = 0.7.*max(max(grad));


%threshold 3 is the number of iterations for this algorithm
while iteration < 60
    
    if iteration == 10
        int1 = PointsList;
    end
    if iteration == 20
        int2 = PointsList;
    end
    
    %get the average distance between all points
    %initialize inner iteration counter and PointsMoved to 0
    davg = AverageD(PointsList);
    inneriteration = 0;
    PointsMoved = 0;    
    
    
    
    %If points moved are less than the minimun number of points need
    %to move in each iteration, keep looping
    %if the number of inner iterations is higher than the number of points
    %it should move, break out and start next iteration.
%     while PointsMoved < frac
%         if inneriteration > frac
%             break;
%         end
%         inneriteration = inneriteration + 1;

        %for each point
        %initialize minimun energy and points moved
        for j = 1:NoOfPoints-1
            Emin = 9999;


            %from second iteration and onwards, if betachange's array is not
            %empty and check if current index is in the array.
            %if true, then this index's beta need to be changed to 0
            if iteration > 1 && ~isempty(betachange)
                if ismember(j,betachange)
                    beta=0;
                else
                    beta=1;
                end
            end

            %get the neighborhood of the current point
            %parameters: points list, index number, neighborhood size
            Vineighbor = neighborhood(PointsList,j,s);

            %calculate continuity energy
            %parameters: points list, index, average distance, neighborhood,
            %size of points list
            Econt = Econtinuity(PointsList,j,davg,Vineighbor,NoOfPoints);

            %calculate curvature energy
            %parameters: points list, index, neighborhood, size of points list
            Ecurv = Ecurvature(PointsList,j,Vineighbor,NoOfPoints);

            %calculate gradient energy
            %parameters: image, neighborhood, 
            Egrad = Egradient(f,Vineighbor);

            %now we have 3 lists for the 3 energies,
            %multiply each by its weight and calculate the final energy
            %and find the minimum energy and its corresponding position
            %(the index in the neighborhood list)
            for i = 1:s.^2

                E(i,:) = (alpha.*Econt(i,1))+(beta.*Ecurv(i,1))+(gamma.*Egrad(i,1));
                if E(i,1) < Emin
                    Emin = E(i,1);
                    position = i;
                end
            end

            %if the neighborhood's point and the current point we are
            %processing are equal, then no need to move
            %otherwise update this point in the points list(move to a new location)
            %count the number of points moved
            if ~isequal(Vineighbor(position,:), PointsList(j,:))
                PointsList(j,:) = Vineighbor(position,:);
                PointsMoved = PointsMoved + 1;
            end

            %update the last entry of the points list to match the first entry
            %reason see report.
            PointsList(NoOfPoints,:) = PointsList(1,:);

        end %end for
%     end
%-------------------------------------------------------------------------

        %calculate Ci for each point and store it in list C
        Cindex = 1;
        for k = 1 : NoOfPoints-1

            %if whether it's first point or other points, find Ui, Ui1 based on
            %formula
            if k == 1
                Ui = [PointsList(k,1)-PointsList(NoOfPoints-1,1), PointsList(k,2)-PointsList(NoOfPoints-1,2)];
            else
                Ui = [PointsList(k,1)-PointsList(k-1,1) , PointsList(k,2)-PointsList(k-1,2)];
            end

            Ui1 = [PointsList(k+1,1)-PointsList(k,1) , PointsList(k+1,2)-PointsList(k,2)];

            %calculation, then add to list C
            Uiprime = Ui./abs(norm(Ui));
            Ui1prime = Ui1./abs(norm(Ui1));
            U=Uiprime-Ui1prime;
            C(Cindex,:) = [norm(U).^2];
            Cindex = Cindex + 1;
        end

        %threshold 1
        Cavg = mean(C);
        thresh1 = 0.001.*Cavg;


        %update the last value of C list to be same as first value(see report)
        %initialize betachange list(reset every iteration)
        C(Cindex,:) = C(1,:); 
        betachange = [];

        %for each point, see if there is a need to relax it
        lindex=1;
        for l = 1:NoOfPoints-1

            %if Ci is greater than both of its negihbors, its threshold1,
            %and the gradient of this point is larger than threshold2
            %set beta to 0 for this point in the next iteration
            if l == 1

                if C(l,1) > C(NoOfPoints-1,1) && C(l,1) > C(l+1,1) && C(l,1) > thresh1 && grad(PointsList(l,2),PointsList(l,1)) > thresh2
                    betachange(lindex,:) = l;
                    lindex = lindex + 1;
                end

            else
                if C(l,1) > C(l-1,1) && C(l,1) > C(l+1,1) && C(l,1) > thresh1 && grad(PointsList(l,2),PointsList(l,1)) > thresh2
                    betachange(lindex,:) = l;
                    lindex = lindex + 1;
                end
            end

        end
   
    %update iteration
    iteration = iteration + 1;

end

out=PointsList;
end
