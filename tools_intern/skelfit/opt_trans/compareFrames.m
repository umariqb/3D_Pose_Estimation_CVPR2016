function dist = compareFrames( mot1, mot2, frame )

nJoints = length(mot1.jointTrajectories);

for i=1:nJoints
    skel1{i} = mot1.jointTrajectories{i}(:,frame);
    skel2{i} = mot2.jointTrajectories{i}(:,frame);
end

dist = costFunL2([0;0;0], skel1, skel2);