function costs = estimateJointPos_costFunRotCenter( x, marker, lastResult)

distPenaltyWeight = 0.2;

nframes = size(marker{1},2);
for i = 1:length(marker)
    d{i} = marker{i} - repmat(x, 1, nframes);
    
    for j=1:size(d{i}, 2)
        dist{i}(j) = norm(d{i}(:,j));
    end
    
    avrgDist(i) = mean(dist{i});
    
    sigma(i) = sum(abs(dist{i} - avrgDist(i)));
    
end

costs = mean(sigma) + distPenaltyWeight * mean(avrgDist);

% d1 = markerGroup1 - repmat(x, 1, size(markerGroup1, 2));
% d2 = markerGroup2 - repmat(x, 1, size(markerGroup2, 2));
% 
% for i=1:size(d1, 2)
%     dist1 = norm(d1(:,i));
% end
% 
% for i=1:size(d2, 2)
%     dist2 = norm(d2(:,i));
% end
% 
% avrgDist1 = mean(dist1);
% avrgDist2 = mean(dist2);
% 
% sigma1 = dist1 - avrgDist1;
% sigma2 = dist2 - avrgDist2;
% 
% costs = sigma1 + sigma2

% global VARS_GLOBAL;
% if isfield(VARS_GLOBAL, 'estimateJointPos_costFunRotCenter_devPenaltyWeight')
%     devPenaltyWeight = VARS_GLOBAL.estimateJointPos_costFunRotCenter_devPenaltyWeight;
% else
%     devPenaltyWeight = 5;
% end
% 
% if isempty(lastResult)
%     devPenalty = 0;
% else
%     devPenalty = devPenaltyWeight * norm(lastResult - x);
% end
% 
% distPenaltyWeight = 0.5;
% 
% for i = 1:size(markerGroup1CoordsF1,2)
%     dist(1,i) = norm(x - markerGroup1CoordsF1(:,i));
% end
% for i = 1:size(markerGroup1CoordsF2_trans,2)
%     dist(1,size(markerGroup1CoordsF1,2)+i) = norm(x - markerGroup1CoordsF2_trans(:,i));
% end
% for i = 1:size(markerGroup2CoordsF1,2)
%     dist(2,i) = norm(x - markerGroup2CoordsF1(:,i));
% end
% for i = 1:size(markerGroup2CoordsF2_trans,2)
%     dist(2,size(markerGroup2CoordsF1,2)+i) = norm(x - markerGroup2CoordsF2_trans(:,i));
% end
%     
% % dist(1,1) = norm(x - markerGroup1CoordsF1(:,1));
% % dist(1,2) = norm(x - markerGroup1CoordsF1(:,2));
% % dist(1,3) = norm(x - markerGroup1CoordsF1(:,3));
% % dist(1,4) = norm(x - markerGroup1CoordsF2_trans(:,1));
% % dist(1,5) = norm(x - markerGroup1CoordsF2_trans(:,2));
% % dist(1,6) = norm(x - markerGroup1CoordsF2_trans(:,3));
% % 
% % dist(2,1) = norm(x - markerGroup2CoordsF1(:,1));
% % dist(2,2) = norm(x - markerGroup2CoordsF1(:,2));
% % dist(2,3) = norm(x - markerGroup2CoordsF1(:,3));
% % dist(2,4) = norm(x - markerGroup2CoordsF2_trans(:,1));
% % dist(2,5) = norm(x - markerGroup2CoordsF2_trans(:,2));
% % dist(2,6) = norm(x - markerGroup2CoordsF2_trans(:,3));
% 
% costs = sum(sum(abs(dist(:,1:3) - dist(:,4:6)))) + distPenaltyWeight * sum(sum(abs(dist))) + devPenalty;
% 
% % IDEE:
% % Rotationszentrum muﬂ in beiden Koordinatensystemen die gleichen Koordinaten haben, d.h. es hat die gleiche
% % relative Position zu den Markern zu beiden Zeitpunkten!