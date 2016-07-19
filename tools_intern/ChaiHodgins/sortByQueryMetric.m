% Input:
% - rotData:        rotation data of all candidates (for Euler angles of size 59 x #candidates)
% - posData:        position data of selected joints of all candidates
% - qlast:          rotation data of last synthesized pose
% - qlastlast:      rotation data of second last synthesized pose
% - controlSignal:  current position data of control markers

function [candidatesSorted,distancesSorted] = sortByQueryMetric(rotData,posData,qlast,qlastlast,controlSignal)

nPoints = size(posData,2);

alpha   = 0.8;
beta    = 0.2;

control_term = sum((posData-repmat(controlSignal,1,nPoints)).^2);

if ~isempty(qlastlast)
    smoothness_term = sum((rotData+repmat(-2*qlast+qlastlast,1,nPoints)).^2);
else
    smoothness_term = 0;
end

distances = alpha * control_term + beta * smoothness_term;
[distancesSorted,candidatesSorted] = sort(distances);