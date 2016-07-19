% remove duplicate vertices and replace indices in patch with new
% vertex indices
function [vertsOut,patchesOut] = removeDupVerts(vertsIn, patchesIn)
patchesOut = patchesIn';
index = [1:size(vertsIn,1);zeros(1,size(vertsIn,1))]';
for i = 1:size(vertsIn,1)
    for j = 1:size(vertsIn,1)
        if(~index(j,2))
            if(vertsIn(i,1) == vertsIn(j,1) &&...
                    vertsIn(i,2) == vertsIn(j,2) &&...
                    vertsIn(i,3) == vertsIn(j,3))
                index(j,1) = i;
                index(j,2) = 1;
            end
        end
    end
end
vertsUsed = intersect(1:size(vertsIn,1), index(:,1));
vertsOut = vertsIn(vertsUsed,:);
for i = 1:size(index,1)
    patchesOut(i) = find(vertsUsed == index(i,1));
end
patchesOut = patchesOut';
end