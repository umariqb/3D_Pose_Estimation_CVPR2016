function [skelFrame, x] = skelfitFrame(mot, boneLengths, skelTree, frame, idxStart1, idxStart2, X0, OPTIONS)


nJoints = length(mot.jointTrajectories);

for i=1:nJoints
    targetSkel{i} = mot.jointTrajectories{i}(:,frame);
end

% disp(num2str(targetSkel{1}));
% disp(' ');

resizedSkel = buildResizedSkel(mot, targetSkel, boneLengths, skelTree, idxStart1, idxStart2); 


if nargin < 7 || isempty(X0)
    X0 = [0;0;0];
end

if nargin < 8
    OPTIONS = OPTIMSET('MaxFunEvals', 500);
    OPTIONS = OPTIMSET('Display','off'); 
%     OPTIONS = OPTIMSET('GradObj','on');
end

x=FMINUNC('costFunL2',X0, OPTIONS, targetSkel, resizedSkel);

skelFrame = translateSkelFrame( resizedSkel, x );