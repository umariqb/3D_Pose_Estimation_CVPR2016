function idxToBeMoved = moveSkelSegment( idx, idxFrom, skelTree )

idxToBeMoved = [idx];

adjJoints = skelTree{idx, 2};

for i=1:length(adjJoints)

    if adjJoints(i)~=idxFrom
        idxToBeMoved = cat(1, idxToBeMoved, adjJoints(i));
        
        idxToBeMoved2 = moveSkelSegment(adjJoints(i), idx, skelTree);
        for j=1:length(idxToBeMoved2)
            if isempty(find(idxToBeMoved==idxToBeMoved2(j)))
                idxToBeMoved = cat(1, idxToBeMoved, idxToBeMoved2(j));
            end
        end
    end
end

