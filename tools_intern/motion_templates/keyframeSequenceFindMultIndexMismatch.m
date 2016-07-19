function [segments,framesTotalNum,matchStart,match] = keyframeSequenceFindMultIndexMismatch(template,keyframes,maxKeyframeSep,extendLeft,extendRight,indexArray)
% [segments,framesTotalNum,matchStart,match] = keyframeSequenceFindMultIndexMismatch(template,keyframes,maxKeyframeSep,extendLeft,extendRight,indexArray)
%
% INPUT:
% ------
% template ............ boolean motion template
% keyframes ........... 3xK array describing the positions and respective indexes for K keyframes: 
%                       row 1 holds column indices into template
%                       row 2 is an index into indexArray
%                       row 3 is number of allowed mismatches (0 or 1)
% maxKeyframeSep ...... maximum distance between first and last frame within a match
% extendLeft .......... number of frames to be added before first frame of a match
% extendRight ......... number of frames to be added behind first frame of a match
% indexArray .......... struct array of index structures
%
% OUTPUT:
% -------
% segments ............ 3xN array describing N segments of the underlying DB:
%                       row 1 holds the document IDs
%                       row 2 holds the start frames
%                       row 3 holds the end frames
% framesTotalNum ...... total number of frames encompassed by the above segments
% matchStart .......... 2xN array describing N matches:
%                       row 1 holds the document IDs
%                       row 2 holds the start frames of the first keyframe
% match ............... KxN array storing the pointer positions for each of the N matches
%


printFlag = false;
%printFlag = true;

%maxKeyframeSep = 200;
%K=4
%keyframeList = cell(K,1);
%keyframeList{1}=[1 1 1 1 2 2 3 3; 3 7 9 11 17 19 23 45];
%keyframeList{2}=[1 1 1 1 2 3 3; 1 5 13 14 21 27 47];
%keyframeList{3}=[1 1 1 3; 2 8 15 30];
%keyframeList{4}=[1 1 1 2 2 3; 4 10 12 26 28 32];

% maxKeyframeSep = 200;
% extendLeft=10;
% extendRight=300;
% K=4;
% keyframeList = cell(K,1);
% load idx
% indexArray = idx;
% keyframeList{1} = indexArray.lists{1};
% keyframeList{2} = indexArray.lists{2};
% keyframeList{3} = indexArray.lists{3};
% keyframeList{4} = indexArray.lists{4};

%K=10;
%keyframeList = cell(K,1);
%load idx
%indexArray = idx;
%for k=1:K
%    keyframeList{k} = indexArray.lists{mod(k,4)+1};
%end

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

keyframeList = cell(1,K);
for k=1:K
    range = indexRanges{keyframes(2,k)};
    V = template(range,keyframes(1,k));
    if (keyframes(3,k)==1)
        indices_nongray = find(V ~= 0.5);
        num_indices_nongray = length(indices_nongray);
        Q_fuzzy = [];
%        keyframeList{k} = [];
        for j=1:num_indices_nongray
            V_modified = V;
            V_modified(indices_nongray(j)) = 0.5;
            h = motionTemplateConvertToFuzzyQuery(V_modified);
            Q_fuzzy = C_union_presorted({Q_fuzzy,h{1}});
%             Q_fuzzy = motionTemplateConvertToFuzzyQuery(V_modified);
%             lists = indexArray(keyframes(2,k)).lists(Q_fuzzy{1});
%             keyframeList{k} = C_union_presorted_2xn([lists; {keyframeList{k}}]); % "fuzzy step": compute union of lists
        end
        keyframeList{k} = C_union_presorted_2xn(indexArray(keyframes(2,k)).lists(Q_fuzzy)); % "fuzzy step": compute union of lists
    else
        Q_fuzzy = motionTemplateConvertToFuzzyQuery(template(range,keyframes(1,k)));
        keyframeList{k} = C_union_presorted_2xn(indexArray(keyframes(2,k)).lists(Q_fuzzy{1})); % "fuzzy step": compute union of lists
    end
end

len = zeros(K,1);
for k=1:K
    len(k) = size(keyframeList{k},2);
end

%time1 = cputime;

%Convert segment indeces into frames
%    - Take last segment frame for first keyframe
%    - Take first segment frame for the remaining keyframes
for m=1:len(1)
    docID = keyframeList{1}(1,m);
    segment = keyframeList{1}(2,m);
    ind = keyframes(2,1);
    keyframeList{1}(2,m) = indexArray(ind).segments(docID).frames_start(segment)+indexArray(ind).segments(docID).frames_length(segment)-1;
end
for k=2:K
    for m=1:len(k)
        docID = keyframeList{k}(1,m);
        segment = keyframeList{k}(2,m);
        ind = keyframes(2,k);
        keyframeList{k}(2,m) = indexArray(ind).segments(docID).frames_start(segment);
    end
end

%time2 = cputime;

pointer = ones(K,1);
match = zeros(K,len(1));
matchNum = 0;
overflow = false;
if printFlag == true
    fprintf('k,pointer,docID,frame\n');
end
for m=1:len(1)
    sameDocID = true;
    docID = keyframeList{1}(1,m);
    %frame = keyframeList{1}(2,m);
    pointer(1)=m;
    for k=2:K
        while (pointer(k)<=len(k)) && ...
                ( (keyframeList{k}(1,pointer(k))<docID) || (keyframeList{k}(1,pointer(k))==docID && keyframeList{k}(2,pointer(k))<keyframeList{k-1}(2,pointer(k-1))) )
            pointer(k) = pointer(k)+1;
        end
        if pointer(k)>len(k)
            overflow = true;
            break;
        end
        if keyframeList{k}(1,pointer(k))>docID
            sameDocID = false;
            break;
        end                       
    end    
    if overflow 
        break;
    elseif sameDocID && (keyframeList{K}(2,pointer(K))-keyframeList{1}(2,m)+1)<=maxKeyframeSep
        matchNum = matchNum+1;
        for k=1:K           
            match(k,matchNum)=pointer(k);
            if printFlag == true            
                fprintf('%5g %5g %5g %5g\n',k,pointer(k),keyframeList{k}(1,pointer(k)),keyframeList{k}(2,pointer(k)));
            end       
        end
        if printFlag == true        
            fprintf('****************\n');                    
        end
    end
end
match = match(:,1:matchNum);
matchStart = [keyframeList{1}(1,match(1,:));keyframeList{1}(2,match(1,:))];

%time3 = cputime;
%fprintf('time: %5.3f/%5.3f, matchNum = %5g',time2-time1,time3-time1,matchNum);

files_frame_length = indexArray(1).files_frame_length;
segmentsNum = 0;
segments = zeros(3,matchNum);
framesTotalNum = 0;
counter = 1;
while counter <= matchNum
    docID = matchStart(1,counter);
    frameStart = max(1,matchStart(2,counter)-extendLeft);
    frameEnd = min(files_frame_length(docID),matchStart(2,counter)+extendRight);
    while counter < matchNum && matchStart(1,counter+1)==docID && max(1,matchStart(2,counter+1)-extendLeft) <=frameEnd
        counter = counter+1;
        frameEnd = min(files_frame_length(docID),matchStart(2,counter)+extendRight);
    end
    segmentsNum = segmentsNum+1;
    segments(1,segmentsNum)=docID;
    segments(2,segmentsNum)=frameStart;
    segments(3,segmentsNum)=frameEnd;
    framesTotalNum = framesTotalNum + frameEnd - frameStart + 1;
    counter = counter+1;
end
segments = segments(:,1:segmentsNum);
  