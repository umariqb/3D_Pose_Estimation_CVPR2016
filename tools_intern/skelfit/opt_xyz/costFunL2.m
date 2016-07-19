function costs = costFunL2( X )

global VARS_GLOBAL_SKELFIT

X2 = VARS_GLOBAL_SKELFIT.traj;
nFrames = VARS_GLOBAL_SKELFIT.frames;

costs = 0;

diff = reshape(X - X2, 3, length(X)/3);
diff = sqrt(dot(diff,diff));
costs = costs + sum(diff);

VARS_GLOBAL_SKELFIT.iter = VARS_GLOBAL_SKELFIT.iter + 1;
VARS_GLOBAL_SKELFIT.costs(VARS_GLOBAL_SKELFIT.iter) = costs;
