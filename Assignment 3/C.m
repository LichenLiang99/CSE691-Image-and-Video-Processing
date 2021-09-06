%%Corner detection function
%%returns Final List of coordinates that are corners
%%'offset' is the N of 2N+1, ie. 9x9 neighborhood have N=4 rows&columns to
%%both top,bot,left,and right.
%'Lrow' is index of row number in the list L.
%'tau' is the threshold value, manually set by multiple testing of the
%algorithm
%'maxlambda' is maximum of all lambda2, so we pick out tau to be less than
%this value
function[FinalList] = C(f,s)
[M,N] = size(f);
offset = floor(s/2);
Lrow=1;
tau=10000;
maxlambda=0;


%define filters
HorizontalFilter = [-1,0,1];
VerticalFilter = [-1; 0; 1];


%get Jx and Jy by convolution
%fix border issues by setting them to 0
Jx = conv2(f,HorizontalFilter,'same');
Jy = conv2(f,VerticalFilter,'same');
Jx(:,1:offset)=0;Jx(:,N-offset:N)=0;
Jy(1:offset,:)=0;Jy(M-offset:M,:)=0;


%get matrix C, were C11 is located at (1,1) in C matrix, same logic for C22, C1221
for i = (1+offset) : (M-offset)
    for j = (1+offset) : (N-offset)
        C11 = sum(sum((Jx(i-offset:i+offset,j-offset:j+offset)).^2));
        C22 = sum(sum((Jy(i-offset:i+offset,j-offset:j+offset)).^2));
        C1221 = sum(sum((Jx(i-offset:i+offset,j-offset:j+offset).*Jy(i-offset:i+offset,j-offset:j+offset))));
        
        %create C matrix
        C = [C11,C1221;C1221,C22];
        
        %find smaller lambda value of C
        lambda2 = min(eig(C));
        
        %update maximum lambda value found
        if lambda2>maxlambda
            maxlambda=lambda2;
        end
        
        %if lambda is larger than threshold tau, place in the list L
        if lambda2 > tau
            L(Lrow,:)= [j,i,lambda2];
            Lrow=Lrow+1;
        end
    end
end
disp("Maximum lambda: " + maxlambda);

%get maximum lambda for picking tau
%sort L by drcreasing order of lambda2
L = sortrows(L,[3 1 2],{'descend'});

%create a Final List, with its indexing value called 'count'
%get first entry of L(indexing called 'Lroww') and add it to final list, while L is not empty, 
%start from sencond entry of L and start comparing if it's in the neighborhood of first entry.
%if it is, delete row from L. After comparing from sencond all the way to
%last, delete the first entry as well, the next one becomes first entry and
%repeat. 
count=1;
while ~isempty(L)
   
   %reset to 1 every iteration, so it can start from top
   Lroww=1;
   
   %add first entry to final list
   FinalList(count,:) = L(Lroww,:);

   %first entry
   tempx1=L(Lroww,1);
   tempx2=L(Lroww,2);
   
   %first entry's neighborhood
   matx=[tempx1-offset:tempx1+offset];
   matx2=[tempx2-offset:tempx2+offset];
   
   %if there is only one row left in L, move it to final list, delete this row, and end loop
   %since there is no more to be compared to
   [P Q] = size(L);
   if P == 1
       FinalList(count+1,:) = L(Lroww,:);
       L(Lroww,:) = [];
       break;
   end
   
   %sencond entry's index, the row after first entry
   Lnextrow = Lroww+1;

   while ~isempty(L)
       
        %second indexes' values
        tempy1=L(Lnextrow,1);
        tempy2=L(Lnextrow,2);
        
        %if the second entry is not the last on the List
        if L(Lnextrow,:) ~= L(end,:)
            
            %compare first and sencond entry, if sencond entry in the
            %first's neighborhood, delete this entry.
            %otherwise, move on to next.
            if ((ismember(tempy1,matx)) && (ismember(tempy2,matx2)))
                L(Lnextrow,:)=[];
            else
                Lnextrow = Lnextrow+1;
            end
            
        %if the sencond entry is last on the list,
        %compare, if in neighborhood, delete entry and break out of this
        %comparison loop. Nothing more to be compared to. 
        %if not in neighborhood, directly break out.
        else
            if ((ismember(tempy1,matx)) && (ismember(tempy2,matx2)))
                L(Lnextrow,:)=[];
                break;
            else
                break;
            end
        end      
   end
   
   %the comparison of first entry from L is done, delete this row as well.
   %the next in line will become the first entry
   %update final list's index as well.
   L(Lroww,:)=[];  
   count=count+1;
end

%diplay the final list size
[R S] = size(FinalList);
disp("Final list size: " + R);

%plot onto image
imshow(f);
axis on
hold on
for ii=1:R
        rectangle('Position',[FinalList(ii,1),FinalList(ii,2), s, s], 'EdgeColor','r');
end
end

