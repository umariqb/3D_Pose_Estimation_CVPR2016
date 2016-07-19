function A = getRotation( points1, points2)
%
% gives the rotation that maps p2 to p1 and q2 to q1 by rotating around rotCenter

global VARS_GLOBAL;
if isfield(VARS_GLOBAL, 'getRotationLastResult')
    lastResult = VARS_GLOBAL.getRotationLastResult;
else
    lastResult = [];
end

startValue = [0 0 0];
LB = [0 0 0]; UB = [2*pi 2*pi 2*pi]; 
% OPTIONS = optimset('Diagnostics', 'off', 'Display', 'off', 'MaxIter', 10000, 'MaxFunEvals', 10000);
OPTIONS = optimset('MaxFunEvals', 1500);
% OPTIONS = [];
% x = fmincon(@costFun, startValue, [], [], [], [], LB,UB, [], OPTIONS, [p1 q1 r1], [p2 q2 r2]);
x = FMINSEARCH(@costFun, startValue, OPTIONS, points1, points2, lastResult);

VARS_GLOBAL.getRotationLastResult = x;

finalCosts = costFun(x, points1, points2, lastResult, true);
A = buildRotMatrixXYZ(x(1), x(2), x(3));


% -------------------------------------------------------------------------------------------------------
function costs = costFun(x, points1, points2, lastResult, trackCosts)

if nargin < 5
    trackCosts = false;
end

if isempty(lastResult)
    devPenalty = 0;
else
    devPenalty = 5*norm(lastResult - x);
end
% disp(devPenalty);

A = buildRotMatrixXYZ(x(1), x(2), x(3));

p = A*points1;
t = mean(points2 - p, 2);

dist = 0;
for i=1:size(points1,2)
    dist = dist + norm( p(:,i) + t - points2(:,i) );
end

%  dist = norm( p(:,1) + t - points2(:,1) ) + norm( p(:,2) + t - points2(:,2) ) + norm( p(:,3) + t - points2(:,3) );

costs = 0;
for i=1:size(points1,2)-1
    v = points2(:,i) - points2(:,i+1);
    w = p(:,i) - p(:,i+1);
    costs = costs - dot( v, w ) / norm(v) / norm(w);
end

% v1 = points2(:,1) - points2(:,2);
% w1 = p(:,1) - p(:,2);
% v2 = points2(:,1) - points2(:,3);
% w2 = p(:,1) - p(:,3);
% costs = - dot( v1, w1 ) / norm(v1) / norm(w1) - dot( v2, w2 ) / norm(v2) / norm(w2);

global VARS_GLOBAL;

if trackCosts
    if isfield(VARS_GLOBAL, 'getRotation_devPenalties')
        VARS_GLOBAL.getRotation_devPenalties(end+1) = devPenalty;
    else
        VARS_GLOBAL.getRotation_devPenalties = devPenalty;
    end
    if isfield(VARS_GLOBAL, 'getRotation_distCosts')
        VARS_GLOBAL.getRotation_distCosts(end+1) = dist;
    else
        VARS_GLOBAL.getRotation_distCosts = dist;
    end
    if isfield(VARS_GLOBAL, 'getRotation_angleCosts')
        VARS_GLOBAL.getRotation_angleCosts(end+1) = costs;
    else
        VARS_GLOBAL.getRotation_angleCosts = costs;
    end
end

if isfield(VARS_GLOBAL, 'getRotation_devPenaltyWeight')
    devPenaltyWeight = VARS_GLOBAL.getRotation_devPenaltyWeight;
else
    devPenaltyWeight = 1.5;
end
costs = costs + 2*dist;
costs = costs + devPenaltyWeight*devPenalty;

% costs = - dot( points2(:,1) - points2(:,2), p(:,1) - p(:,2) ) - dot( points2(:,1) - points2(:,3), p(:,1) - p(:,3) );

% if costs < -1.5
%     disp(costs);
% end
