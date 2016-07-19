function X = skelfitFrame(X0, OPTIONS)

% tic;
global VARS_GLOBAL_SKELFIT
frames = VARS_GLOBAL_SKELFIT.frames;
traj = VARS_GLOBAL_SKELFIT.traj;
VARS_GLOBAL_SKELFIT.iter = 0;
VARS_GLOBAL_SKELFIT.costs = [];

ub = [];
lb = [];
ub = traj + 5;
lb = traj - 5;

if nargin < 1 || isempty(X0)
    X0 = zeros(length(traj),1);
end

if nargin < 2
    OPTIONS = OPTIMSET('MaxFunEvals', 50);
    OPTIONS = OPTIMSET('GradObj','off');
end

X=FMINCON('costFunL2',X0,[],[],[],[],lb,ub,'constrFunFixedLengths', OPTIONS);
% toc