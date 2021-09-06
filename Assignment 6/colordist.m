%calculates the delta from color distance function.
%direct implementation from section 2.3 in paper
%equations ans steps see report.
function delta = colordist(xt,Vcurr)
    tempxt = ((xt(1)).^2 + (xt(2)).^2 + (xt(3)).^2);
    tempVcurr = ((Vcurr(1))^2 + (Vcurr(2))^2 + (Vcurr(3))^2);
    xtVcurr = (xt(1)*Vcurr(1) + xt(2)*Vcurr(2) + xt(3)*Vcurr(3)).^2;
    p = xtVcurr/tempVcurr;
    delta = sqrt(tempxt - p);
end