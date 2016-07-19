function [segments,framesTotalNum, laufzeitBerechnet, laufzeitReal] = keyframeSequenceFindStrechedLinearRanged(template,keyframes,indexArray, stiffness, DB_concat)
    % [segments,framesTotalNum] = keyframeSequenceFindMultIndexMismatch(template,keyframes,indexArray, stiffness)
    %
    % INPUT:
    % ------
    % template ............ boolean motion template
    % keyframes ........... 3xK array describing the positions and respective indexes for K keyframes:
    %                       row 1 holds column indices into template
    %                       row 2 is an index into indexArray
    %                       row 3 is number of allowed mismatches (0 or 1)
    % indexArray .......... struct array of index structures
    % stiffness  .......... 0 <= stiffness <= 1 describes how stiff the distances
    %                       the keyframes have to match the database. 1 means
    %                       absolutely stiff, 0 means: least stiffness.
    % OUTPUT:
    % -------
    % segments ............... 3xN array describing N segments of the underlying DB:
    %                       row 1 holds the document IDs
    %                       row 2 holds the start frames
    %                       row 3 holds the end frames
    % framesTotalNum ...... total number of frames encompassed by the above segments
    
    global K;
    global breakRecursion;
    K = size(keyframes,2);
    J = length(indexArray);

    indexRanges = cell(J,1);
    for j=1:J
        if (j==1)
            indexRanges{1} = 1:indexArray(j).features_num;
        else
            indexRanges{j} = indexRanges{j-1}(end)+1:indexRanges{j-1}(end)+indexArray(j).features_num;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% Visualisierung %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global visualize;
    global dbFigure;
    global height;
    global files_frame_start;
    visualize = false;
    if nargin > 4
        visualize = true;
        templateFigure = figure;
        imagesc(template);
        colormap gray;
        set(templateFigure, 'name', 'Keyframes and found positions');
        %title(gca, 'Magenta: Keyframes. Yellow: relative positions of keyframes in database');
        height = size(template,1);
        for k = 1:K
            line('XData', [keyframes(1,k) keyframes(1,k)],...
            'YData', [1 height], ...
            'Color', 'magenta',...
            'LineWidth', 3);
        end
        
        
        dbFigure = draw_DB_concat(DB_concat);
        files_frame_start = DB_concat.files_frame_start;
        
    end
    
    
  

    keyframeList = cell(1,K);
    for k=1:K
        range = indexRanges{keyframes(2,k)};
        Q_fuzzy = motionTemplateConvertToFuzzyQuery(template(range,keyframes(1,k)));
        keyframeList{k} = C_union_presorted_2xn(indexArray(keyframes(2,k)).lists(Q_fuzzy{1})); % "fuzzy step": compute union of lists
    end

    % keyframesList{1} enthält nun die Positionen, an denen in der Datenbank
    % der erste Keyframe vorkommt. Die erste Zeile in keyframesList{1} sind die
    % DokumentenID's, die zweite Zeile sind die Segment-Indizes. Diese
    % Segment-Indizes müssen erst noch in Frames umgewandelt werden.

    len = zeros(K,1);
    for k=1:K
        len(k) = size(keyframeList{k},2);
    end

    %time1 = cputime;

    % Convert segment indices into frames
  
    % At the same time build save the keyframes into a data structure that can
    % help to find properly streched keyframes.
    % keyframeBuckets is a cell array. the Nth row contains all keyframes found
    % in the Nth documentID, each of it saved in the correct column: the first
    % column contains a frame list for the query keyframe 1, the second
    % column contains a frame list for the query keyframe 2 and so on.
    % The frame lists are built up as follows: All indices i with i%2 == 1
    % are start frames of a segment and all indices i with i%2 == 0 are end
    % frames of a segment. Two entries describe one segment with its start
    % and end frame positions.
    % currently it works with only ONE indexArray!
    files_num = indexArray(1).files_num;

    global keyframeBuckets;
    keyframeBuckets = cell(files_num, K);
    bucketsSizes = zeros(files_num, K);
    for k=1:K
        for m=1:len(k)
            docID = keyframeList{k}(1,m);
            segment = keyframeList{k}(2,m);
            ind = keyframes(2,k);
            segmentStart = indexArray(ind).segments(docID).frames_start(segment);
            segmentLength = indexArray(ind).segments(docID).frames_length(segment);
            
%             keyframeBuckets{docID, k} = [keyframeBuckets{docID, k}, ...
%                                          segmentStart, ...
%                                          segmentStart + segmentLength - 1];

            keyframeBuckets{docID, k}(bucketsSizes(docID, k)+1) = segmentStart;
            keyframeBuckets{docID, k}(bucketsSizes(docID, k)+2) = segmentStart + segmentLength - 1;
            bucketsSizes(docID, k) = bucketsSizes(docID, k) +2;
            
            
            if visualize
                if ishandle(dbFigure)
%                     figure(dbFigure);
                    lineStart = files_frame_start(docID) + segmentStart -1;
                    lineEnd = files_frame_start(docID)  + segmentStart + segmentLength - 2;
                    lineRow = k;
                    line('XData', [lineStart-0.25 lineEnd+0.25],...
                        'YData', [lineRow lineRow], ...
                        'Color', 'green',...
                        'LineWidth', 3);
                    
                end
            end

        end
    end

    if nargout > 2
        laufzeitBerechnet = 0;
        for docID = 1:files_num
            for k=1:K-1
                laufzeitBerechnet = laufzeitBerechnet + ...
                    (K-k)*size(keyframeBuckets{docID, k},2);
            end
            laufzeitBerechnet = laufzeitBerechnet + size(keyframeBuckets{docID, k},2);
            laufzeitBerechnet = laufzeitBerechnet - ((K-2)*(K-1))/2;
        end
    end
            
    
    % match is a data structure that describes the sequence of frames which
    % match to the keyframes. The first column contains the document ID,
    % the second column the start frame and the third column contains the
    % end frame.

    global match; %define it global to allow the recursive function to access it.
    match = []; % preallocate: which size can match have?
    global matchNum; %define it global to allow the recursive function to access it.
    matchNum = 0;

    % if the found sequence is shorter than minMatchLength it cannot be a hit
    % because of the dtw stepsize condition (maximum slope 2, min slope 1/2)
    extendLeft = 3*(keyframes(1, 1));
    extendRight = 3*(size(template,2) - keyframes(1, end) + 1);



    % the length of every document has to be known to prevent from extending a found
    % match longer than the document length.
    files_frame_length = indexArray(1).files_frame_length;

    
%     keyframeDistance = zeros(1,K-1);
%     for k=1:K-1
%         keyframeDistance(k) = keyframes(1,k+1) - keyframes(1, k);
%     end
    keyframeDistance = diff(keyframes(1, :));
    
    global distanceMinMax;
    %distanceMinMax = ([stiffness; 2-stiffness]*keyframeDistance)';
    distanceMinMax = ([stiffness; 1/stiffness]*keyframeDistance)';
    distanceMinMax(:,1) = ceil(distanceMinMax(:,1));
    distanceMinMax(:,2) = floor(distanceMinMax(:,2));    
    
    if visualize
        disp('Keyframes:')
        disp(keyframes(1, :));

        disp('Keyframe distances:');
        disp(keyframeDistance);        
        
        disp('distanceMinMax:');
        disp(distanceMinMax);
        
        
    end
    %distanceMinMax: K-1 rows, 2 columns
    %[D1min, D1max;
    % D2min, D2max;
    % D3min, D3max;
    % ...
    % ]
    
    
    

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

    global counter;
    counter = 0;
    
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
        % stiffness condition. Fill matchFrames with the result.
        keyframePointer = ones(1, K);
        keyframeBucketFirstKeyframe = keyframeBuckets{docID, 1};
        
        breakRecursion = false;
        keyframePointer(1) = 1;
        while (~breakRecursion) && keyframePointer(1) <= size(keyframeBucketFirstKeyframe, 2)
            allowedRange = keyframeBucketFirstKeyframe(keyframePointer(1):keyframePointer(1)+1)+...
                            distanceMinMax(1,:);
            counter = counter + 1;
            keyframeSequenceFindRecursive(docID, 2, allowedRange);
            keyframePointer(1) = keyframePointer(1) + 2;
        end

    end
    
    
    disp(['Summe der Listenlängen: ' num2str(sum(len))]);

    disp(['Anzahl betrachteter Listenelemente: ' num2str(counter)]);
    if (nargout > 2)
        laufzeitReal = counter;
    end
    if matchNum == 0
        % No matches were found --> return.
        segments = [];
        framesTotalNum = 0;
        %close all;
        return;
    end
    
    % remove overlappings and extend matches
    segments = zeros(3, size(match, 2));
    segmentsNum = 1;
    segments(1, segmentsNum) = match(1,1);
    segments(2, segmentsNum) = max(match(2, 1) - extendLeft, 1);
    segments(3, segmentsNum) = min(match(3, 1) + extendRight,  files_frame_length(match(1,1)));

    
    for i = 2:matchNum;
       segmentsNum = segmentsNum + 1;
        segments(1, segmentsNum) = match(1, i);
        segments(2, segmentsNum) = max(match(2, i) - extendLeft, 1);
        segments(3, segmentsNum) = min(match(3, i) + extendRight,  files_frame_length(match(1,i)));
        %overlapping = this start frame is
        %before the end frame of the previous
        %match and of course the document id's have to be the same.
        overlapping = segments(1, segmentsNum-1) == match(1, i) ...
            && match(2,i) < segments(3, segmentsNum-1);
        if overlapping
            %create a match that
            %covers all overlapped frames.
            segments(3, segmentsNum-1) = segments(3, segmentsNum);
            segmentsNum = segmentsNum - 1;
        end

    end
    segments = segments(:, 1:segmentsNum);

    % filter out those segments which are too short to be a dtw-hit.
%     minMatchLength = floor(size(template, 2)/2);
%     segments = segments(:, (segments(3, :) - segments(2, :)) >= minMatchLength);
%     
    framesTotalNum = sum(segments(3, :) - segments(2, :) + 1, 2);
    
    clear distanceMinMax;
    clear keyframePointer;
    clear match;
    clear matchNum;
    clear keyframeBuckets;
    clear K;
    clear visualize;
    clear dbFigure;
    clear height;
    clear files_frame_start;
    clear break_recursion;
    clear counter;
    %close all;
    
end % end function



function keyframeSequenceFindRecursive(docID, keyframeNr, allowedRange)

    global distanceMinMax;
    global keyframePointer;
    global match;
    global matchNum;
    global keyframeBuckets;
    global K;
    global visualize;
    global dbFigure;
    global height;
    global files_frame_start;
    global breakRecursion;
    
    global counter;
    counter = counter + 1;

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
        % this is the last keyframe. Report any matches.
        % while the allowedRange interval intersects the keyframe interval
        % report any match.
        while keyframePointer(K) <= size(keyframes, 2) ...
                && allowedRange(2) >= keyframes(keyframePointer(keyframeNr)) ...
                && allowedRange(1) <= keyframes(keyframePointer(keyframeNr)+1)
            
            % we have found a match. light it ;-)
            counter = counter + 1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%% Visualisierung %%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if visualize
                % draw found frames into the
                % Database-figure
                if ishandle(dbFigure)
                    
                    figure(dbFigure);
                    lineHandleDB=zeros(1,K);
                    for n=1:K
                        frames = keyframeBuckets{docID, n};
                        lineRow = frames(keyframePointer(n)) + ...
                                floor( (frames(keyframePointer(n)+1) - frames(keyframePointer(n)) )/2) + ...
                                files_frame_start(docID) - 1;
                            
                        
                        lineHandleDB(n)=line('XData', [lineRow lineRow],...
                            'YData', [1 height], ...
                            'Color', 'yellow',...
                            'LineWidth', 1);
                    end
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%% Visualisierung Ende %%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
            
            
            matchNum = matchNum + 1;
            match(1, matchNum) = docID;
            firstSegmentStart = keyframeBuckets{docID, 1}(keyframePointer(1));
            firstSegmentEnd = keyframeBuckets{docID, 1}(keyframePointer(1)+1);
            lastSegmentStart = keyframeBuckets{docID, K}(keyframePointer(K));
            lastSegmentEnd  = keyframeBuckets{docID, K}(keyframePointer(K)+1);
            match(2, matchNum) = firstSegmentStart + ...
                                 floor((firstSegmentEnd - firstSegmentStart)/2);
            match(3, matchNum) = lastSegmentStart + ...
                                 floor((lastSegmentEnd - lastSegmentStart)/2);
            keyframePointer(K) = keyframePointer(K) + 2;
            % if keyframePointer(K) > size(keyframes, 2): break recursion!
        end
        if keyframePointer(K) > size(keyframes, 2)
            breakRecursion = true;
        end
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
            intersection = [max(currentSegment(1), allowedRange(1)), ...
                            min(currentSegment(2), allowedRange(2))];
            newAllowedRange = intersection + ...
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

