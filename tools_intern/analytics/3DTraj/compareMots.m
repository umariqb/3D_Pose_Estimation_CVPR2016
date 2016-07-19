function [diffSum, diffMean, diffStd, diffMax, diffMin, diffDerivMax] = compareMots( mot1, mot2, justTotals, noGraphics, noText)
% [diffSum, diffMean, diffStd, diffMax, diffMin, diffDerivMax] = compareMots( mot1, mot2, justTotals, noGraphics, noText)

if nargin < 1
    help compareMots;
    return;
end

if length(mot1.jointTrajectories{1}) ~= length(mot2.jointTrajectories{1})
    error('Files have different number of frames and cannot be compared!');
end

if nargin < 5
    noText = false;
end
if nargin < 4
    noGraphics = false;
end
if nargin < 3
    justTotals = false;
end

% determine subplot dimensions
b = length(mot1.nameMap);
m = floor(sqrt(b));

if m*m ~= b
    m = m + 1;
end

n = double(int32(b/m));

if mod(b,m)~=0
    n = n + 1;
end

totalSum = 0;

if not(noGraphics)
    figure;
end

jointNames = getAllJointNames;
totalDiff = [];
for i=1:b   
    jointName = jointNames{i};
    idx1 = trajectoryID(mot1, jointName);
    idx2 = trajectoryID(mot2, jointName);

    difference = mot1.jointTrajectories{idx1} - mot2.jointTrajectories{idx2};
    difference = sqrt(dot(difference, difference));
    totalDiff = [totalDiff difference];
    diffSum(i,1) = sum(difference);
    diffMean(i,1) = mean(difference);
    diffStd(i,1) = std(difference);
    diffMax(i,1) = max(difference);
    diffMin(i,1) = min(difference);
    diffDerivMax(i,1) = max(diff(difference));
    totalSum = totalSum + sum(difference);
    
    if not(noGraphics)
        subplot(m,n,i), plot(difference);
    end
end

if not(noText)
    disp(' ');
    disp(['Avr. error is ' num2str(totalSum / b / length(mot1.jointTrajectories{1})) ' per frame per joint']);
    disp(['Standard deviation of error is ' num2str(std(totalDiff))]);
    disp(['Min. error is ' num2str(min(diffMin)) ', max. error is ' num2str(max(diffMax))]);
    disp(' ');
end

if justTotals
    diffSum = sum(diffSum);
    diffMean = totalSum / b / length(mot1.jointTrajectories{1});
    diffStd = std(totalDiff);
    diffMin = min(diffMin);
    diffMax = max(diffMax);
end