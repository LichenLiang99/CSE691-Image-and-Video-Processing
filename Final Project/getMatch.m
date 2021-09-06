%match the sift feature and descrpitor using the tool box function
%vl_ubcmatch.

function [MatchPair] = getMatch(featureI, DescriptorI, featureJ, DescriptorJ)

[match, ~] = vl_ubcmatch(DescriptorI, DescriptorJ);

NumberOfMatches = size(match,2);
MatchPair = nan(NumberOfMatches, 3, 2);

MatchPair(:,:,1)=[featureI(2,match(1,:));featureI(1,match(1,:));ones(1,NumberOfMatches)]';
MatchPair(:,:,2)=[featureJ(2,match(2,:));featureJ(1,match(2,:));ones(1,NumberOfMatches)]';

end
