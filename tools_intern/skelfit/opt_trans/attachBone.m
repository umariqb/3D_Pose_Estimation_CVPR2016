function skel = attachBone( j1, j2, skel, skelTree, targetSkel, boneLengths)

% disp(['processing bone ' num2str(j1) '/' num2str(j2)]);

for i=1:length(boneLengths)
    if (boneLengths(i,1)==j1 && boneLengths(i,2)==j2) || (boneLengths(i,2)==j1 && boneLengths(i,1)==j2)
        idx = i;
        break;
    end
end

goalLength = boneLengths(idx(1),3);
goalVector = (targetSkel{j2} - targetSkel{j1});

if goalVector ~= [0;0;0]
    goalVector = goalVector / sqrt(dot(goalVector, goalVector)) * goalLength;
end

skel{j2} = skel{j1} + goalVector;

succ = skelTree{j2,2};
for i=succ
    if i~=j1
        skel = attachBone( j2, i, skel, skelTree, targetSkel, boneLengths );
    end
end

