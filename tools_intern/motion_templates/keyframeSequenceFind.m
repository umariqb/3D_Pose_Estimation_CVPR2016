function [segments,framesTotalNum,matchStart,match] = keyframeSequenceFind(list,maxKeyframeSep,extendLeft,extendRight,idx)

printFlag = false;
%printFlag = true;

%maxKeyframeSep = 200;
%K=4
%list = cell(K,1);
%list{1}=[1 1 1 1 2 2 3 3; 3 7 9 11 17 19 23 45];
%list{2}=[1 1 1 1 2 3 3; 1 5 13 14 21 27 47];
%list{3}=[1 1 1 3; 2 8 15 30];
%list{4}=[1 1 1 2 2 3; 4 10 12 26 28 32];

% maxKeyframeSep = 200;
% extendLeft=10;
% extendRight=300;
% K=4;
% list = cell(K,1);
% load idx
% list{1} = idx.lists{1};
% list{2} = idx.lists{2};
% list{3} = idx.lists{3};
% list{4} = idx.lists{4};

%K=10;
%list = cell(K,1);
%load idx
%for k=1:K
%    list{k} = idx.lists{mod(k,4)+1};
%end

K = length(list);

len = zeros(K,1);
for k=1:K
    len(k) = size(list{k},2);
end

%time1 = cputime;

%Convert segment indeces into frames
%    - Take last segment frame for first keyframe
%    - Take first segment frame for the remaining keyframes
for m=1:len(1)
    docID = list{1}(1,m);
    segment = list{1}(2,m);
    list{1}(2,m) = idx.segments(docID).frames_start(segment)+idx.segments(docID).frames_length(segment)-1;
end
for k=2:K
    for m=1:len(k)
        docID = list{k}(1,m);
        segment = list{k}(2,m);
        list{k}(2,m) = idx.segments(docID).frames_start(segment);
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
    docID = list{1}(1,m);
    %frame = list{1}(2,m);
    pointer(1)=m;
    for k=2:K
        while (pointer(k)<=len(k)) && ...
                ( (list{k}(1,pointer(k))<docID) || (list{k}(1,pointer(k))==docID && list{k}(2,pointer(k))<list{k-1}(2,pointer(k-1))) )
%                ( (list{k}(1,pointer(k))<docID) || (list{k}(1,pointer(k))==docID && list{k}(2,pointer(k))<=list{k-1}(2,pointer(k-1))) )
            pointer(k) = pointer(k)+1;
        end
        if pointer(k)>len(k)
            overflow = true;
            break;
        end
        if list{k}(1,pointer(k))>docID
            sameDocID = false;
            break;
        end                       
    end    
    if overflow 
        break;
    elseif sameDocID && (list{K}(2,pointer(K))-list{1}(2,m)+1)<=maxKeyframeSep
        matchNum = matchNum+1;
        for k=1:K           
            match(k,matchNum)=pointer(k);
            if printFlag == true            
                fprintf('%5g %5g %5g %5g\n',k,pointer(k),list{k}(1,pointer(k)),list{k}(2,pointer(k)));
            end       
        end
        if printFlag == true        
            fprintf('****************\n');                    
        end
    end
end
match = match(:,1:matchNum);
matchStart = [list{1}(1,match(1,:));list{1}(2,match(1,:))];

%time3 = cputime;
%fprintf('time: %5.3f/%5.3f, matchNum = %5g',time2-time1,time3-time1,matchNum);

segmentsNum = 0;
segments = zeros(3,matchNum);
framesTotalNum = 0;
counter = 1;
while counter <= matchNum
    docID = matchStart(1,counter);
    frameStart = max(1,matchStart(2,counter)-extendLeft);
    frameEnd = min(indexArray.files_frame_length(docID),matchStart(2,counter)+extendRight);
    while counter < matchNum && matchStart(1,counter+1)==docID && max(1,matchStart(2,counter+1)-extendLeft) <=frameEnd
        counter = counter+1;
        frameEnd = min(indexArray.files_frame_length(docID),matchStart(2,counter)+extendRight);
    end
    segmentsNum = segmentsNum+1;
    segments(1,segmentsNum)=docID;
    segments(2,segmentsNum)=frameStart;
    segments(3,segmentsNum)=frameEnd;
    framesTotalNum = framesTotalNum + frameEnd - frameStart + 1;
    counter = counter+1;
end
segments = segments(:,1:segmentsNum);
  