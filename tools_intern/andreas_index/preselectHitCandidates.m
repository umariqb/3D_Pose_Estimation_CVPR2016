%function [segments,framesTotalNum] = preselectHitCandidates(keyframes,keyframeDistances, stiffness, indexArray, extendLeft, extendRight, varargin)
function [segments,framesTotalNum, varargout] = preselectHitCandidates(keyframes, keyframeIndex, keyframeDistances, stiffness, indexArray, extendLeft, extendRight, varargin)
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
    
    global K;
    global breakRecursion;
    K = size(keyframes,2);
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% Visualisierung %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global visualize;
    global dbFigure;
    global height;
    global files_frame_start;
    global matchingFrames;
    
    visualize = false;
    if nargin > 7
        visualize = true;
%         templateFigure = figure;
%         imagesc(template);
%         colormap gray;
%         set(templateFigure, 'name', 'Keyframes and found positions');
%         %title(gca, 'Magenta: Keyframes. Yellow: relative positions of keyframes in database');
          height = size(keyframes{1},1);
%         for k = 1:K
%             line('XData', [keyframes(1,k) keyframes(1,k)],...
%             'YData', [1 height], ...
%             'Color', 'magenta',...
%             'LineWidth', 3);
%         end
        DB_concat = varargin{1};
        dbFigure = draw_DB_concat(DB_concat);
        varargout{1} = dbFigure;
        files_frame_start = DB_concat.files_frame_start;
%         userData = cell('keyframes', keyframes, 'keyframeDistances', keyframeDistances, 'stiffness', stiffness, 'extendLeft', extendLeft, 'extendRight', extendRight);
%         set(dbFigure, 'UserData', userData);
%         files_frame_start = DB_concat.files_frame_start;
%         
%         for k=1:size(DB_concat.files_name)
%             l= line(DB_concat.files_frame_start(k), mod(k, height)+1, ...
%                 'Marker', '.',...
%                 'Color', 'magenta');
%             set(l, 'MarkerSize', 15);
%             set(l, 'buttondownfcn',{@showFeatures,...
%                                       DB_concat.files_name{k}, ...
%                                       keyframes,...
%                                       keyframeIndex,...
%                                       keyframeDistances,...
%                                       stiffness,...
%                                       extendLeft,...
%                                       extendRight...
%                                       
%                                });   
% 
% 
%         end
    end
    
    
  

    keyframeList = cell(1,K);
    for k=1:K
        Q_fuzzy = motionTemplateConvertToFuzzyQuery(keyframes{k});
        keyframeList{k} = C_union_presorted_2xn(indexArray(keyframeIndex(k)).lists(Q_fuzzy{1})); % "fuzzy step": compute union of lists
    end

    % keyframesList{1} enthält nun die Positionen, an denen in der Datenbank
    % der erste Keyframe vorkommt. Die erste Zeile in keyframesList{1} sind die
    % DokumentenID's, die zweite Zeile sind die Segment-Indizes. Diese
    % Segment-Indizes müssen erst noch in Frames umgewandelt werden.

    len = zeros(K,1);
    for k=1:K
        len(k) = size(keyframeList{k},2);
    end

    % Convert segment indices into segments with start and and frame.
  
    % At the same time save the keyframes into a data structure that can
    % help to find properly streched keyframes.
    % keyframeBuckets is a cell array. 
    % keyframeBuckets(n,k) contains a vector with all segments found
    % in the nth document that match to the kth keyframe.
    % The vectors are built up as follows: All indices i with i%2 == 1
    % are start frames of a segment and all indices i with i%2 == 0 are end
    % frames of a segment. Two entries describe one segment with its start
    % and end frame positions.
    % currently it works with only ONE indexArray!
    files_num = indexArray(1).files_num;
    
    global keyframeBuckets;
    keyframeBuckets = cell(files_num, K);
    bucketsSizes = zeros(files_num, K);
    for k=1:K
        lastDocID = -1;
        lastSegment = -1;
        for m=1:len(k)
            docID = keyframeList{k}(1,m);
            segment = keyframeList{k}(2,m);
            %ind = keyframes(2,k);
            ind = keyframeIndex(k);

            segmentStart = indexArray(ind).segments(docID).frames_start(segment);
            segmentLength = indexArray(ind).segments(docID).frames_length(segment);

            % Nachsegmentierung: Direkt nebeneinander liegende Segmente
            % werden vereinigt zu einem größeren Segment.
            if docID == lastDocID && segment == (lastSegment+1)
                % Zwei Segmente lagen direkt nebeneinander.
                % Vereinige sie, indem das letzte gespeicherte Element im
                % aktuellen Keyframebucket verlängert wird.
                % ("Nachsegmentieren")
                keyframeBuckets{docID, k}(bucketsSizes(docID, k)) = segmentStart + segmentLength - 1;
            else 
                lastDocID = docID;
                keyframeBuckets{docID, k}(bucketsSizes(docID, k)+1) = segmentStart;
                keyframeBuckets{docID, k}(bucketsSizes(docID, k)+2) = segmentStart + segmentLength - 1;
                bucketsSizes(docID, k) = bucketsSizes(docID, k) +2;
            end
            lastSegment = segment;
        end
    end

    if visualize % draw the frames that match to the each keyframe with green horizontal lines.
        for k=1:K
            for docID = 1:files_num
                bucket = keyframeBuckets{docID, k};
                i=1;
                while i < length(bucket)
                    if ishandle(dbFigure)
                        

            %                     figure(dbFigure);
                        lineStart = files_frame_start(docID) + bucket(i) - 1;
                        lineEnd   =  files_frame_start(docID) + bucket(i+1) - 1;
                        lineRow = k;
                        line('XData', [lineStart-0.25 lineEnd+0.25],...
                            'YData', [lineRow lineRow], ...
                            'Color', 'green',...
                            'LineWidth', 3);
                    else
                        break;
                    end
                    i = i + 2;
                end
            end                
        end
    end    
    
    
    % hit is a data structure that describes the sequence of frames which
    % match to the keyframes regarding the stiffness condition.
    % The first column contains the document ID of the hit,
    % the second column the start frame of the hit
    % and the third column contains the end frame of the hit.

    global hits; %define it global to allow the recursive function to access it.
    hits = []; % preallocate: which size can hit have?
    global hitsNum; %define it global to allow the recursive function to access it.
    hitsNum = 0;

    % if the found sequence is shorter than minMatchLength it cannot be a hit
    % because of the dtw stepsize condition (maximum slope 2, min slope 1/2)
    % extendLeft = 3*(keyframes(1, 1));
    % extendRight = 3*(size(template,2) - keyframes(1, end) + 1);

    % the length of every document has to be known to prevent from extending a found
    % match longer than the document length.
    files_frame_length = indexArray(1).files_frame_length;

    global distanceMinMax;
    %distanceMinMax = ([stiffness; 1/stiffness]*keyframeDistances)';
    if (isscalar(stiffness))
        stiffness = stiffness * ones(1, length(keyframeDistances));
    end
    stiffnessMatrix = [stiffness; 1./stiffness];
%     stiffnessMatrix = [stiffness; 2-stiffness];
    distanceMatrix = [keyframeDistances; keyframeDistances];
    distanceMinMax = (stiffnessMatrix .* distanceMatrix)';
    distanceMinMax(:,1) = ceil(distanceMinMax(:,1));
    distanceMinMax(:,2) = floor(distanceMinMax(:,2));    
    
    if visualize
        disp('Keyframes:')
        disp(keyframes);

        disp('Keyframe distances:');
        disp(keyframeDistances);        
        
        disp('distanceMinMax:');
        disp(distanceMinMax);
          
    end
   
    
    global keyframePointer;
    keyframePointer = ones(1, K);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% TEST DATA SET 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     files_num = 1;
%     K = 3;
%     keyframeBuckets = cell(files_num, K);
%     keyframeBuckets{1, 1} = [2,5,  7,7];
%     
%     keyframeBuckets{1, 2} = [7,7,   11,15];
% 
%     keyframeBuckets{1, 3} = [ 7,7,  9,10,   11,15, 24,25, 26,29, 32,34];
% 
%     keyframeDistance = [6, 10];
%     stiffness = 0.8;
%     distanceMinMax = ([stiffness; 1/stiffness]*keyframeDistance)';
%     distanceMinMax(:,1) = ceil(distanceMinMax(:,1));
%     distanceMinMax(:,2) = floor(distanceMinMax(:,2));
%     
%     extendLeft = 5;
%     extendRight = 10;
%     files_frame_length = 150;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% TEST DATA SET 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% TEST DATA SET 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     files_num = 1;
%     K = 4;
%     keyframeBuckets = cell(files_num, K);
%     keyframeBuckets{1, 1} = [1,1, 2, 2, 3,3, 4,4];
%     
%     keyframeBuckets{1, 2} = [2, 3, 4,5];
% 
%     keyframeBuckets{1, 3} = [3,4,5, 6];
% 
%     keyframeBuckets{1, 4} = [8,8];%[4,4, 5,5, 6,6, 7,7];
% 
%     keyframeDistance = [1, 1, 1, 1, 1, 1];
%     stiffness = 1.0;
%     distanceMinMax = ([stiffness; 1/stiffness]*keyframeDistance)';
%     distanceMinMax(:,1) = ceil(distanceMinMax(:,1));
%     distanceMinMax(:,2) = floor(distanceMinMax(:,2));
%     
%     extendLeft = 5;
%     extendRight = 10;
%     files_frame_length = 150;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% TEST DATA SET 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    global intersection;
    intersection = cell(1, K);

    
    if visualize && ishandle(dbFigure)
        figure(dbFigure);
    end

    % check buckets for every document
    for docID = 1:files_num
        % check if one bucket is empty. if one is empty we don't have to do
        % anything for this document because one of the keyframes didn't match
        % the document!
%         bucketSize = zeros(1, K);
        empty = false;
        for k=1:K
            %bucketSize(k) = size(keyframeBuckets{docID, k}, 2);
            if size(keyframeBuckets{docID, k}, 2) == 0
                empty = true;
                break;
            end
        end
        
        if empty %~isempty(find(bucketSize == 0, 1))
            % one bucket is empty for this document.
            % proceed to the next document.
            continue;
        end


        % look for frames in the buckets that fit to the keyframes and the
        % stiffness condition. Fill hits with the result.
        keyframePointer = ones(1, K);
        keyframeBucketFirstKeyframe = keyframeBuckets{docID, 1};
        
        breakRecursion = false;
        keyframePointer(1) = 1;
        while (~breakRecursion) && keyframePointer(1) <= size(keyframeBucketFirstKeyframe, 2)
            allowedRange = keyframeBucketFirstKeyframe(keyframePointer(1):keyframePointer(1)+1)+...
                            distanceMinMax(1,:);
            intersection{1} = keyframeBucketFirstKeyframe(keyframePointer(1):keyframePointer(1)+1);
            keyframeSequenceFindRecursive(docID, 2, allowedRange);
            keyframePointer(1) = keyframePointer(1) + 2;
        end

    end
    
    
    if hitsNum == 0
        % No matches were found --> return.
        segments = [];
        framesTotalNum = 0;
        varargout = {[],[]};
        %close all;
        return;
    end
    
    % remove overlappings and extend matches
    segments = zeros(3, size(hits, 2));
    segmentsNum = 1;
    segments(1, segmentsNum) = hits(1,1);
    segments(2, segmentsNum) = max(hits(2, 1) - extendLeft, 1);
    segments(3, segmentsNum) = min(hits(3, 1) + extendRight,  files_frame_length(hits(1,1)));

    
    for i = 2:hitsNum;
       segmentsNum = segmentsNum + 1;
        segments(1, segmentsNum) = hits(1, i);
        segments(2, segmentsNum) = max(hits(2, i) - extendLeft, 1);
        segments(3, segmentsNum) = min(hits(3, i) + extendRight,  files_frame_length(hits(1,i)));
        %overlapping = this start frame is
        %before the end frame of the previous
        %hit and of course the document id's have to be the same.
        overlapping = segments(1, segmentsNum-1) == hits(1, i) ...
            && max(hits(2, i) - extendLeft, 1) < segments(3, segmentsNum-1);
        if overlapping
            %create a segment that
            %covers all overlapped hits.
            segments(3, segmentsNum-1) = segments(3, segmentsNum);
            matchingFrames = matchingFrames(setdiff(1:end, segmentsNum));
            segmentsNum = segmentsNum - 1;
            
        end

    end
    segments = segments(:, 1:segmentsNum);

    % filter out those segments which are too short to be a dtw-hit.
%     minHitLength = floor(size(template, 2)/2);
%     segments = segments(:, (segments(3, :) - segments(2, :)) >= minHitLength);
%     
    framesTotalNum = sum(segments(3, :) - segments(2, :) + 1, 2);
    if (nargout > 3)
        varargout{2} = matchingFrames;
    end
    
   if visualize
    % draw found hits into the
    % Database-figure
    if ishandle(dbFigure)
        for n=1:segmentsNum
            docID = segments(1, n);
            lineStart = segments(2, n) + files_frame_start(docID) - 1;                 
            lineEnd = segments(3, n) + files_frame_start(docID) - 1;   
            line('XData', [lineStart lineEnd],...
                'YData', [size(keyframes{1},1), size(keyframes{1},1)], ...
                'Color', 'magenta',...
                'LineWidth', 3);
        end
    end
   end
   
  
    
    clear distanceMinMax;
    clear keyframePointer;
    clear hits;
    clear hitsNum;
    clear keyframeBuckets;
    clear K;
    clear visualize;
    clear dbFigure;
    clear height;
    clear files_frame_start;
    clear break_recursion;
    %close all;
    
end % end function



function keyframeSequenceFindRecursive(docID, keyframeNr, allowedRange)

    global distanceMinMax;
    global keyframePointer;
    global hits;
    global hitsNum;
    global keyframeBuckets;
    global K;
    global visualize;
    global dbFigure;
    global height;
    global files_frame_start;
    global breakRecursion;
    global intersection;
    global matchingFrames;
    if breakRecursion 
        return;
    end
    
    % forward listpointer until we are in the allowedRange
    % while the minimum of the allowed interval is less then
    % the maximum of the keyframe interval an intersection is impossible.
    keyframes= keyframeBuckets{docID, keyframeNr};
    while keyframePointer(keyframeNr) <= size(keyframes, 2) ...
            && allowedRange(1) > keyframes(keyframePointer(keyframeNr)+1)
        
        keyframePointer(keyframeNr) = keyframePointer(keyframeNr) + 2;
    end
    % now the keyframePointer(keyframeNr) either points into the
    % allowedRange or behind the allowedRange.
    
    
    if (keyframeNr == K)
        % this is the last keyframe. Report any hits.
        % while the allowedRange interval intersects the keyframe interval
        % report any hit.
        found = false;
        while keyframePointer(K) <= size(keyframes, 2) ...
                && allowedRange(2) >= keyframes(keyframePointer(keyframeNr)) ...
                && allowedRange(1) <= keyframes(keyframePointer(keyframeNr)+1)
            found = true;
            % we have found a match. light it ;-)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%% Visualisierung %%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if visualize
                % draw found frames into the
                % Database-figure
                if ishandle(dbFigure)

                    lineHandleDB=zeros(1,K);
                    for n=1:K
                        frames = keyframeBuckets{docID, n};
                        lineRow = frames(keyframePointer(n)) + ...
                                (frames(keyframePointer(n)+1) - frames(keyframePointer(n)) )/2 + ...
                                files_frame_start(docID) - 1;
                            
                        
                        lineHandleDB(n)=line('XData', [lineRow lineRow],...
                            'YData', [n height], ...
                            'Color', 'yellow',...
                            'LineWidth', 1);
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%% Visualisierung Ende %%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            

            % calculate intersection of the current segment and the allowed
            % range.
            currentSegment = keyframes(keyframePointer(K):keyframePointer(K)+1);
            
            intersection{K} = [max(currentSegment(1), allowedRange(1)), ...
                            min(currentSegment(2), allowedRange(2))];
           
            
            hitsNum = hitsNum + 1;
            hits(1, hitsNum) = docID;

            % Reconstruction of hits: Convert a match (a set of pointers
            % into the segmented inverted list) into a hit (a set of frames
            % inside the segments. the stiffness condition holds for these
            % frames).           
            index = zeros(1,K);
            index(K) = intersection{K}(2);
            
            matchingFrames{hitsNum} = zeros(K, 2);
            matchingFrames{hitsNum}(K,:) = intersection{K}(2);
            for k=K-1:-1:1
                I=[index(k+1), index(k+1)] - fliplr(distanceMinMax(k,:));
                J=[max(I(1), intersection{k}(1)),...
                    min(I(2), intersection{k}(2))];
                if J(1) > J(2)
                    error('Error in the reconstruction of hits: An illegal interval occured!');
                end
                matchingFrames{hitsNum}(k,:)=J;
                
                index(k) = J(1);
            end
            hits(3, hitsNum) = index(K);
            hits(2, hitsNum) = index(1);            

            keyframePointer(K) = keyframePointer(K) + 2;
        end
        if found
            keyframePointer(K) = keyframePointer(K) - 2;
        end
%         if keyframePointer(K) > size(keyframes, 2)
%             breakRecursion = true;
%         end
%         
    else
        % this is not the first keyframe and not the last keyframe. If we
        % find frame intervals that intersect the allowed range then we have to recurse.
        found = false;
        while keyframePointer(keyframeNr) <= size(keyframes, 2) ...
                && allowedRange(2) >= keyframes(keyframePointer(keyframeNr))...
                && allowedRange(1) <= keyframes(keyframePointer(keyframeNr)+1)
            
            currentSegment = keyframes(keyframePointer(keyframeNr):keyframePointer(keyframeNr)+1);
            % calculate intersection of the current segment and the allowed
            % range.
            intersection{keyframeNr} = [max(currentSegment(1), allowedRange(1)), ...
                            min(currentSegment(2), allowedRange(2))];
            newAllowedRange = intersection{keyframeNr} + ...
                    distanceMinMax(keyframeNr,:);            
            keyframeSequenceFindRecursive(docID, keyframeNr+1, newAllowedRange);
            keyframePointer(keyframeNr) = keyframePointer(keyframeNr) + 2;
            found = true;
        end
        if found
            keyframePointer(keyframeNr) = keyframePointer(keyframeNr) - 2;
        end
    end

end % end function keyframeSequenceFindRecursive

