function [averageface,favg] = AverageFace(X,M,N)

favg = mean(X,2);
f2 = reshape(favg, M, N);
averageface = uint8(f2);
end