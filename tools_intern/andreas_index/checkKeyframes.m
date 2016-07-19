function checkKeyframes(keyframeFeatureSet, keyframes, keyframeIndex, keyframePositions, stiffness)

if (isempty(keyframes))
    error('Manual keyframes for this class aren''t defined yet.');
end
 
ranges = get_feature_set_ranges(keyframeFeatureSet);

for k = 1:length(keyframes)
    %first check if other values than 0, 0.5 and 1.0 are contained.
    I=intersect(intersect(find(keyframes{k} ~= [0]), find(keyframes{k} ~= [0.5])), find(keyframes{k} ~= [1]));
    if ~isempty(I)
        error(['Keyframe ' num2str(k) ' contains an invalid number']);
    end
    %then check the dimension of the keyframes
    if length(keyframes{k}) ~= length(ranges{keyframeIndex(k)})
        error(['Dimension of keyframe ' num2str(k) ' incorrect. Should be length ' num2str(length(ranges{keyframeIndex(k)}))]); 
    end
    
end

%check keyframe positions
I= find (diff(keyframePositions) < 0);
if ~isempty(I)
    error(['Keyframe Positions are not ascending']);
end

%check stiffness
I=union(find(stiffness <0), find(stiffness > 1.0));
if ~isempty(I)
    error(['Stiffness out of range']);
end
if (length(stiffness) ~= (length(keyframePositions)-1))
    error(['Stiffness dimension doesn''t match!']);
end