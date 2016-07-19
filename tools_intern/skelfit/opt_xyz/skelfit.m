function mot_new = skelfit( mot_c3d, fromFrame, toFrame )

if nargin < 2
    fromFrame = 1;
end
if nargin < 3
    toFrame = mot_c3d.nframes;
end

global VARS_GLOBAL_SKELFIT;

VARS_GLOBAL_SKELFIT = [];
mot_new = mot_c3d;
mot_new.jointTrajectories = [];
nJoints = length(mot_c3d.jointTrajectories);

disp('frame ');

for i=fromFrame:toFrame

    if i==1
        disp( [char(8) num2str(i)] );
    else
        disp([repmat(char(8),1,length(num2str(i-1))+1) num2str(i)]);
    end

	for j=1:nJoints
         VARS_GLOBAL_SKELFIT.traj(3*j-2:3*j,1) = mot_c3d.jointTrajectories{j}(:,i);
	end
	
	VARS_GLOBAL_SKELFIT.frames = 1;
	VARS_GLOBAL_SKELFIT.boneLengths = calculateBoneLengths(mot_c3d);
	VARS_GLOBAL_SKELFIT.iter = 0;

    X = skelfitFrame;
    
	for j=1:nJoints
        mot_new.jointTrajectories{j}(:,i-fromFrame+1) = X(3*j-2:3*j);
    end
    
end