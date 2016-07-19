% Divides the keyframe template into keyframesNumMax sections of equal
% length. In each section the keyframe with the lease gray values will be
% selected.
function [keyframes,keyframesIndex] = keyframesChooseLeastGrayValuesEquallyDistributed(motionTemplate,motionTemplateWeights,par)
irgnoreBorderPortion = 0.1;

ignoredFrames = floor(size(motionTemplate, 2) * irgnoreBorderPortion);
motionTemplate = motionTemplate(:,ignoredFrames+1:end-ignoredFrames);

numFrames = size(motionTemplate,2);

keyframes = zeros(1, par.keyframesNumMax);


numGrayEntries = zeros(1,numFrames);
numGrayEntries(1,:) = sum(motionTemplate==0.5,1);

sectionLength = floor(numFrames / par.keyframesNumMax);
currentFrame = 1;
for k=1:par.keyframesNumMax-1
    [numGrayEntriesSorted, sortIndex] = sort(numGrayEntries(currentFrame:currentFrame + (sectionLength-1)));
    keyframes(1, k) = currentFrame-1 + sortIndex(1) + ignoredFrames;
    currentFrame = currentFrame + sectionLength + 1;
end
[numGrayEntriesSorted, sortIndex] = sort(numGrayEntries(currentFrame:end));
keyframes(1, end) = currentFrame-1 + sortIndex(1) + ignoredFrames;


keyframesIndex = ones(size(keyframes));
    

