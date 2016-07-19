function mot = skelfitATSrek( mot, jointIdx, skelTree, parentJoints )

childIdx = skelTree{jointIdx,2};

for i=1:length(childIdx)
    if not(ismember(childIdx(i), parentJoints))
        mot = refitBone(mot, jointIdx, childIdx(i));
        mot = skelfitATSrek(mot, childIdx(i), skelTree, [parentJoints jointIdx]);
    end
end
