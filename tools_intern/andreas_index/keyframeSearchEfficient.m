function [segments,framesTotalNum, varargout] = keyframeSearchEfficient(keyframes, keyframeIndex, keyframeDistances, stiffness, indexArray, extendLeft, extendRight, varargin)
    %
    % INPUT:
    % ------
    % keyframes ........... 1xK cell Array. Each entry contains one Fx1
    %                       feature vector V. This vector V is a keyframe.
    %                       The entries are 0 (feature value has to be 0),
    %                       1 (the feature value has to be 1) or 0.5 (the
    %                       feature value can be 0 or 1).
    % keyframeIndex ....... 1xK Vecor. Each entry tells to wich index
    %                       structure this keyframe belongs.
    %                       [3, 1, 2] means, that the first keyframe 
    %                       belongs to the third inverted file index,
    %                       the second keyframe belongs to the first
    %                       inverted file index and the third keyframe
    %                       to the second inverted file index.
    % keyframeDistances ... 1x(K-1) vector containing the frame distances
    %                       of the keyframes. The first entry describes the
    %                       distance between keyframes{1} and keyframes{2}.
    % stiffness  .......... 0 <= stiffness <= 1 describes how stiff the
    %                       keyframeDistances have to match the database. 
    %                       stiffness = 1 means absolutely stiff, 
    %                       stiffness = 0 means: no stiffness. The
    %                       mathematical definition is as follows: Recall
    %                       that keyframeDistance(k) is the distance between
    %                       keyframes{k} and keyframes{k+1}. Let delta(k)
    %                       be the distance of the database frames that match to
    %                       keyframes{k} and keyframes{k+1}. Then
    %                       stiffenss*distance(k) <= delta(k) <= distance(k)/stiffness 
    %                       holds.
    % indexArray .......... struct array of inverted list index structures.
    %                       These index structures are referred by the 
    %                       keyframeIndex entries.
    % extendLeft .......... Amount of frames that tells how many frames
    %                       each hit should be extended to the left.
    % extendRight ......... Amount of frames that tells how many frames
    %                       each hit should be extended to the right.
    % varargin ............ Add the search database DB_concat to the parameter list
    %                       if you want the function to visualize the
    %                       process of this algorithm. Leave it out if
    %                       you dont't want it to be visualized.
    % OUTPUT:
    % -------
    % segments ...........  3xN array describing N segments of the
    %                       underlying DB. The hits that are found by this
    %                       algorithm are extended to the left and right to
    %                       allow further temporal deformation. If 2
    %                       segments overlap then they are concatenated to one large
    %                       segment. The resulting set of segments is
    %                       returned.
    %                       row 1 holds the document IDs
    %                       row 2 holds the start frames
    %                       row 3 holds the end frames
    % framesTotalNum ...... total number of frames encompassed by the above segments
    
    K = size(keyframes,2);

    keyframeList = cell(1,K);
    len = zeros(K,1);
    for k=1:K
        Q_fuzzy = motionTemplateConvertToFuzzyQuery(keyframes{k});
        keyframeList{k} = C_union_presorted_2xn(indexArray(keyframeIndex(k)).lists(Q_fuzzy{1})); % "fuzzy step": compute union of lists
        len(k) = size(keyframeList{k},2);
    end

     if (isscalar(stiffness))
        stiffness = stiffness * ones(1, length(keyframeDistances));
    end
    stiffnessMatrix = [stiffness; 1./stiffness];
%     stiffnessMatrix = [stiffness; 2-stiffness];
    distanceMatrix = [keyframeDistances; keyframeDistances];
    distanceMinMax = (stiffnessMatrix .* distanceMatrix)';
    distanceMinMax(:,1) = ceil(distanceMinMax(:,1));
    distanceMinMax(:,2) = floor(distanceMinMax(:,2));    
    distanceMinMax(isnan(distanceMinMax)) = inf; %define 0/0 := inf
    %check if something went wrong with distanceMinMax
    if (sum( (distanceMinMax(:,2) - distanceMinMax(:,1))<0) > 0)
        error('Something went wrong with the keyframe distances.');
    end


    %t = C_GetTime;
%     t = C_Clockticks;
    segments = C_KeyframeSearch(indexArray, keyframeList, keyframeIndex, distanceMinMax, extendLeft, extendRight);
    framesTotalNum = sum(segments(3, :) - segments(2, :) + 1, 2);
%     recursionTime = C_ClockticksSubstract(t);    
    
    varargout = {};
 
    if (nargout > 4)
        % calculate the list lenghts and assign them to an output variable
        varargout{3} = len;
    end
    if (nargout > 5)
        %measure the time taken for the recursion
        varargout{4} = recursionTime;
    end
   
end % end function
