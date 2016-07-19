function [mot_new, translations] = skelfitOptT2( motC3D, fromFrame, toFrame, noDisplay )

if nargin < 2
    fromFrame = 1;
end
if nargin < 3
    toFrame = motC3D.nframes;
end
if nargin < 4
    noDisplay = false;
end

boneLengths = calculateBoneLengths(motC3D);
skelTree = buildSkelTree(motC3D.nameMap);

mot_new = motC3D;
mot_new.jointTrajectories = [];
mot_new.nframes = toFrame - fromFrame + 1;
nJoints = length(motC3D.jointTrajectories);

idxLtoes = strmatch('ltoes', motC3D.nameMap(:,1));
idxLankle = strmatch('lankle', motC3D.nameMap(:,1));

if ~noDisplay
    disp('frame ');
end

warning off;
for i=fromFrame:toFrame
    
    if ~noDisplay
        if i==1
            disp( [char(8) num2str(i)] );
        else
            disp([repmat(char(8),1,length(num2str(i-1))+1) num2str(i)]);
        end
    end
    
    [skelFrame, translations(:,i)] = skelfitFrame(motC3D, boneLengths, skelTree, i, idxLtoes, idxLankle);
    
    for j=1:nJoints
        mot_new.jointTrajectories{j,1}(:,i-fromFrame+1) = skelFrame{j};
    end
    
end
warning on;