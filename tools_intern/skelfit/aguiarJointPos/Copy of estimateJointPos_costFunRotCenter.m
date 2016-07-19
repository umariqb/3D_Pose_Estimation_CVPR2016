function costs = estimateJointPos_costFunRotCenter( x, markerGroup1CoordsF1, markerGroup2CoordsF1, markerGroup1CoordsF2_trans, markerGroup2CoordsF2_trans, lastResult)

global VARS_GLOBAL;
if isfield(VARS_GLOBAL, 'estimateJointPos_costFunRotCenter_devPenaltyWeight')
    devPenaltyWeight = VARS_GLOBAL.estimateJointPos_costFunRotCenter_devPenaltyWeight;
else
    devPenaltyWeight = 5;
end

if isempty(lastResult)
    devPenalty = 0;
else
    devPenalty = devPenaltyWeight * norm(lastResult - x);
end

distPenaltyWeight = 0.5;

for i = 1:size(markerGroup1CoordsF1,2)
    dist(1,i) = norm(x - markerGroup1CoordsF1(:,i));
end
for i = 1:size(markerGroup1CoordsF2_trans,2)
    dist(1,size(markerGroup1CoordsF1,2)+i) = norm(x - markerGroup1CoordsF2_trans(:,i));
end
for i = 1:size(markerGroup2CoordsF1,2)
    dist(2,i) = norm(x - markerGroup2CoordsF1(:,i));
end
for i = 1:size(markerGroup2CoordsF2_trans,2)
    dist(2,size(markerGroup2CoordsF1,2)+i) = norm(x - markerGroup2CoordsF2_trans(:,i));
end
    
% dist(1,1) = norm(x - markerGroup1CoordsF1(:,1));
% dist(1,2) = norm(x - markerGroup1CoordsF1(:,2));
% dist(1,3) = norm(x - markerGroup1CoordsF1(:,3));
% dist(1,4) = norm(x - markerGroup1CoordsF2_trans(:,1));
% dist(1,5) = norm(x - markerGroup1CoordsF2_trans(:,2));
% dist(1,6) = norm(x - markerGroup1CoordsF2_trans(:,3));
% 
% dist(2,1) = norm(x - markerGroup2CoordsF1(:,1));
% dist(2,2) = norm(x - markerGroup2CoordsF1(:,2));
% dist(2,3) = norm(x - markerGroup2CoordsF1(:,3));
% dist(2,4) = norm(x - markerGroup2CoordsF2_trans(:,1));
% dist(2,5) = norm(x - markerGroup2CoordsF2_trans(:,2));
% dist(2,6) = norm(x - markerGroup2CoordsF2_trans(:,3));

costs = sum(sum(abs(dist(:,1:3) - dist(:,4:6)))) + distPenaltyWeight * sum(sum(abs(dist))) + devPenalty;

% IDEE:
% Rotationszentrum muﬂ in beiden Koordinatensystemen die gleichen Koordinaten haben, d.h. es hat die gleiche
% relative Position zu den Markern zu beiden Zeitpunkten!