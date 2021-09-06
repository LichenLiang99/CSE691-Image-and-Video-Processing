%Hysteresis Threshold
%using In from nms function, Eo of that image, user set high and low
%threshold.
%the output should be a less complicated version of the nms.
function[out] = HThreash(In,Eo,Th,Tl)

[M, N] = size(In);

%zeropad output image
%create a matrix to keep track of visited and non visited coordinates.
%start out with all 0s(unvisited), and set to 1 once visited
out = zeros(M,N);
visited = zeros(M,N);

%borders are ignored
for i = 2 : M-1
    for j = 2 : N-1
        
        %for each In who have threshold larger than Th
        %set it as a starting point
        if In(i,j) > Th
            out(i,j) = 255;
            
            %need to keep track of initial i and j values in order to
            %return to find next starting point.
            %Defined x and y to look for neighbor values that are greater
            %than Tl
            x=i;
            y=j;
            while(In(x,y)>Tl)
                
                %if visited, return to find next i,j location, otherwise
                %set it as visited and move on
                if visited(x,y)==1
                    break;
                end
                visited(x,y)=1;

                %for each (x,y), find its Eo value, and compare its
                %corresponding neighbors, if the neighbor is greater than
                %Tl, update that to be the new (x,y) for next iteration.
                %If both neighbors are less than Tl, return to find next (i,j)
                %In the case of both neighbors are greater than Tl, the
                %next (x,y) is based on the order I wrote this code.
                %i.e when Eo is 0 degrees and both left and right neighbors
                %are > Tl, the left neighbor is always used, based on the
                %code.
                if Eo(x,y) == 0
                    if In(x,y-1) > Tl
                        out(x,y-1)=255;
                        y = y-1;
                    elseif In(x,y+1) > Tl
                        out(x,y+1) = 255;
                        y = y+1;
                    else
                        break;
                    end
                
                elseif Eo(x,y) == 45
                    if In(x+1,y-1) > Tl
                        out(x+1,y-1)=255;
                        x = x+1;
                        y = y-1;
                    elseif In(x-1,y+1) > Tl
                        out(x-1,y+1) = 255;
                        x = x-1;
                        y = y+1;
                    else
                        break;
                    end
                elseif Eo(x,y) == 90
                    if In(x+1,y) > Tl
                        out(x+1,y)=255;
                        x = x+1;
                    elseif In(x-1,y) > Tl
                        out(x-1,y) = 255;
                        x = x-1;
                    else
                        break;
                    end
                elseif Eo(x,y) == 135
                    if In(x-1,y-1) > Tl
                        out(x-1,y-1)=255;
                        x = x-1;
                        y = y-1;
                    elseif In(x+1,y+1) > Tl
                        out(x+1,y+1) = 255;
                        x = x+1;
                        y = y+1;
                    else
                        break;
                    end
                else
                    break
                end
            end %while
        end %if > Th
    end %for j
end %for i
end %func
    