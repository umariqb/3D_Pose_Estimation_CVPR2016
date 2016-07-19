mot = mot_c3d;
factor = length(mot.jointTrajectories{1});

global VARS_GLOBAL_SKELFIT;

VARS_GLOBAL_SKELFIT = [];

frames = length(mot.jointTrajectories{1});
I = factor*[1:frames/factor];
I = 2650;

for i=1:length(mot.jointTrajectories)
%     VARS_GLOBAL_SKELFIT.traj{i} = mot.jointTrajectories{i}(:,I);
     VARS_GLOBAL_SKELFIT.traj(3*i-2:3*i,1) = mot.jointTrajectories{i}(:,I);
end

VARS_GLOBAL_SKELFIT.frames = floor(frames/factor);
VARS_GLOBAL_SKELFIT.boneLengths = calculateBoneLengths(mot);
VARS_GLOBAL_SKELFIT.iter = 0;

clear frames;
clear I;
clear mot;
clear i;
clear factor;