function [skelFrame, x] = skelfitFrame(mot, boneLengths, skelTree, frame, idxStart1, idxStart2, X0, OPTIONS)


nJoints = length(mot.jointTrajectories);

for i=1:nJoints
    targetSkel{i} = mot.jointTrajectories{i}(:,frame);
end

% disp(num2str(targetSkel{1}));
% disp(' ');

resizedSkel = buildResizedSkel(mot, targetSkel, boneLengths, skelTree, idxStart1, idxStart2); 

x = [0;0;0];
for i=1:nJoints
    x = x + targetSkel{i} - resizedSkel{i};
end

x = x ./ nJoints;

skelFrame = translateSkelFrame( resizedSkel, x );