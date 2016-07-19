function mot_new = skelfit( skel, mot, fromFrame, toFrame, iterations )

global VARS_GLOBAL_SKELFIT;

VARS_GLOBAL_SKELFIT = [];
VARS_GLOBAL_SKELFIT.nodes = skel.nodes;
VARS_GLOBAL_SKELFIT.rootRotationalOffsetQuat = skel.rootRotationalOffsetQuat;
VARS_GLOBAL_SKELFIT.nJoints = length(mot.jointTrajectories);

nJoints = VARS_GLOBAL_SKELFIT.nJoints;

mot_new = mot;
mot_new.jointTrajectories = [];
mot_new.rotationQuat = [];
mot_new.nframes = toFrame - fromFrame + 1;

for i=fromFrame:toFrame

    VARS_GLOBAL_SKELFIT.frame = i;

    for j=1:nJoints
        VARS_GLOBAL_SKELFIT.jointTrajectories{j,1}(:,1) = mot.jointTrajectories{j}(:,i);  % marker positions of current frame
    end

    X = skelfitFrame(iterations);
    
	for j=1:nJoints
        mot_new.rotationQuat{j,1}(:,i-fromFrame+1) = X( 4*j : 4*j+3 );
    end
    mot_new.rootTranslation(:,i) = X(1:3);
    
end