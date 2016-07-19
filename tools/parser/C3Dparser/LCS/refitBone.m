function mot = refitBone( mot, jointIdx1, jointIdx2 )
% enforces fixed bone length for this bone over all frames of the animation

% determine desired length
% crop to length

diffVect = mot.jointTrajectories{jointIdx2} - mot.jointTrajectories{jointIdx1};
diffLen  = sqrt(dot(diffVect,diffVect));
targetLength = mean(diffLen);

mot.jointTrajectories{jointIdx2} = mot.jointTrajectories{jointIdx1} + targetLength * (diffVect ./ [diffLen;diffLen;diffLen]);