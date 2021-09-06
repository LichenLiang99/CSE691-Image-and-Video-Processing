%return a true or false value.
%direct implementation from section 2.3 in paper
%equations ans steps see report.
function bit = brightness(xt,Imin,Imax,alpha,beta)
    Ilow = alpha.*Imax;
    Ihi = min((beta.*Imax),Imin./alpha);
    
    if Ilow <= norm(xt) && Ihi >= norm(xt)
        bit = 1;
    else
        bit = 0;
    end
end