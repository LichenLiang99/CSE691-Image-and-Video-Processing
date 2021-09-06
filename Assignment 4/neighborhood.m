%gets the neighborhood of the current point depending on the neighborhood
%size.
function [neighbors] = neighborhood(PointsList,index,s)

    Vix = PointsList(index,1);
    Viy = PointsList(index,2);
    
    if s == 3
        neighbors = [Vix-1,Viy-1;Vix-1,Viy;Vix-1,Viy+1;...
                  Vix,Viy-1;Vix,Viy;Vix,Viy+1;...
                  Vix+1,Viy-1;Vix+1,Viy;Vix+1,Viy+1];
    end
    if s == 5
        neighbors = [Vix-2,Viy-2;Vix-2,Viy-1;Vix-2,Viy;Vix-2,Viy+1;Vix-2,Viy+2;...
                     Vix-1,Viy-2;Vix-1,Viy-1;Vix-1,Viy;Vix-1,Viy+1;Vix-1,Viy+2;...      
                     Vix,Viy-2;Vix,Viy-1;Vix,Viy;Vix,Viy+1;Vix,Viy+2;...
                     Vix+1,Viy-2;Vix+1,Viy-1;Vix+1,Viy;Vix+1,Viy+1;Vix+1,Viy+2;...
                     Vix+2,Viy-2;Vix+2,Viy-1;Vix+2,Viy;Vix+2,Viy+1;Vix+2,Viy+2;];
                     
    end