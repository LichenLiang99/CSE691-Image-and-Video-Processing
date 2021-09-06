function FilteredCB = tfilter(M,N,Nframes,codebook)
    s=M.*N;
    for i= 1:s
        index=1;
        cb=codebook(i);
        curr = cb{1};
        tempcurr = curr{1};
        tempVcurr = tempcurr{1}{1};
        tempAuxcurr = tempcurr{1}{2};
%         Vcurr = tempVcurr{1};
%         Auxcurr = tempAuxcurr{1};
        if(tempAuxcurr(4)<= Nframes/2)
            temp = {{tempVcurr},{tempAuxcurr}};
            temp2(index) = {temp};
            index = index+1;
        end
        FilteredCB(i)={temp2};

    end
end