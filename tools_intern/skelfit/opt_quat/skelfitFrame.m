function X = skelfitFrame(iterations, X0, OPTIONS)

tic;
global VARS_GLOBAL_SKELFIT
VARS_GLOBAL_SKELFIT.costs = [];
nJoints = VARS_GLOBAL_SKELFIT.nJoints;

ub = [];
lb = [];

if nargin < 2 || isempty(X0)
%     X0 = zeros(nJoints*4 + 3, 1);  % one Quaternion for each joint + rootTranslation (x,y,z)
    X0(1:3) = [0;0;0];
    X0(4:nJoints*4+3) = repmat([1;0;0;0], nJoints, 1);
end

if nargin < 2
    OPTIONS = OPTIMSET('MaxFunEvals', iterations);
    OPTIONS = OPTIMSET('GradObj','on');
end

% X=FMINCON('costFunQuat',X0,[],[],[],[],lb,ub,[], OPTIONS);
X=FMINUNC('costFunQuat', X0, OPTIONS);
% X=FMINSEARCH('costFunQuat', X0, OPTIONS);
toc