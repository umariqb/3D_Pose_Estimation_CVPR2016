function [keyframes,keyframesIndex] = keyframesChooseLeastGrayValues(motionTemplate,motionTemplateWeights,par)
irgnoreBorderPortion = 0.15;

ignoredFrames = floor(size(motionTemplate, 2) * irgnoreBorderPortion);


keyframes = [];
numGrayEntries = sum(motionTemplate(:,ignoredFrames+1:end-ignoredFrames)==0.5,1);

[numGrayEntriesSorted, sortIndex] = sort(numGrayEntries);
numFrames = size(numGrayEntriesSorted,2);

%compensate for cutted frames ab the start of the motion
sortIndex = sortIndex + ignoredFrames;

keyframes(1, 1) = sortIndex(1);
keyframesNum = 1;

for k=2:numFrames
    if keyframesNum >= par.keyframesNumMax 
        break;
    end
    currentFrame = sortIndex(k);
    %check distance to every other keyframe
    distanceOkay = true;
    for n = 1:keyframesNum
        distance = abs(keyframes(1, n) - currentFrame);
        if distance < par.keyframeMinDist
            distanceOkay = false;
            break;
        end
    end
    if distanceOkay
        keyframesNum = keyframesNum+1;
        keyframes(1, keyframesNum) = currentFrame;
    end
end

keyframes=sort(keyframes);
keyframesIndex = ones(size(keyframes));
    

