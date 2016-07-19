function boneLengths = calculateBoneLengths( mot )

nJoints = length(mot.jointTrajectories);
nFrames = length(mot.jointTrajectories{1});

skelBones = extractSkelBones(mot.nameMap);

for i=1:length(skelBones)
    idx1 = skelBones{i}(1);
    idx2 = skelBones{i}(2);
    traj1 = mot.jointTrajectories{idx1};
    traj2 = mot.jointTrajectories{idx2};
    
    diff = traj1-traj2;
    diff = sqrt(dot(diff,diff));
    
    boneLengths(i,1) = idx1;
    boneLengths(i,2) = idx2;
    boneLengths(i,3) = mean(diff);
end
