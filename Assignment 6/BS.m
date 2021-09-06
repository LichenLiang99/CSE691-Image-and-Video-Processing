%background subtraction function
%returns a black and white image
function out = BS(FilteredCB,M,N,alpha,beta,epsilon,f)

    codebookindex=0;
    
    %for each pixel from the input image, retrieve its RGB values and form
    %xt and I similar to before.
    %extract the xt and Aux from filtered codebook, then compare the color
    %distance and brightness,
    %it delta is less than epsilon and brightness is true, then it's
    %background, and set that pixel to black(0), otherwise set it to
    %white(255)
    for i = 1:M
        for j = 1:N
            codebookindex = codebookindex+1;
            R=f(i,j,1);
            G=f(i,j,2);
            B=f(i,j,3);
            xt = [R,G,B];
            I = R+G+B;
            
            cb=FilteredCB{codebookindex};
            tempcurr=cb{1};
            tempVcurr = tempcurr{1}{1};
            tempAuxcurr = tempcurr{2};
            Vcurr=tempVcurr{1};
            Auxcurr=tempAuxcurr{1};
            
            delta = colordist(xt,Vcurr);
            bit = brightness(xt,Auxcurr(1),Auxcurr(2),alpha,beta);
            
            if (delta<epsilon) && (bit == 1)
                out(i,j)=0;
            else
                out(i,j)=255;
            end
        end
    end

end