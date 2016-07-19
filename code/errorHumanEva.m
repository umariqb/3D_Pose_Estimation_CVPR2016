function [errPrJnts, errPrFr, errPrAllFr] = errorHumanEva(data,mocapGT,cJoints)
% data = data(1:3*length(cJoints),:);
% mocapGT = mocapGT(1:3*length(cJoints),:);

errPrFr   = nan(size(data,2),1);                   % error nrOfFrames
errPrJnts = nan(size(data,1)/3,1,size(data,2));    % error joints*knn*nrOfFrames

for f = 1:size(data,2)            % frames
    errPrJntsTmp = nan(size(data,1)/3,1);
    i = 1;
    for j = 1:size(data,1)/3      % joints
        errPrJntsTmp(j) = error_internal(data(i:i+2,f),mocapGT(i:i+2,f));
        i = i + 3;
    end
    errPrJnts(:,1,f) = errPrJntsTmp;
    errPrFr(f) = mean(errPrJntsTmp);
end
errPrAllFr = mean(errPrFr);
end

function [err] = error_internal(point1, point2)
err = sqrt(sum((point1(:) - point2(:)).^2));
end



%%
% % % % Thorax joint
% % % e1 = error_internal(pose1.torsoProximal, pose2.torsoProximal);
% % % e2 = error_internal(pose1.headProximal, pose2.headProximal);
% % % if (any([e1, e2]))
% % %     err(end+1) = mean([e1, e2]);
% % % end
% % % % Pelvis joint
% % % err(end+1)  = error_internal(pose1.torsoDistal, pose2.torsoDistal);
% % % % Left shoulder
% % % err(end+1)  = error_internal(pose1.upperLArmProximal, pose2.upperLArmProximal);
% % % % Left elbow
% % % e1 = error_internal(pose1.upperLArmDistal, pose2.upperLArmDistal);
% % % e2 = error_internal(pose1.lowerLArmProximal, pose2.lowerLArmProximal);
% % % if (any([e1, e2]))
% % %     err(end+1) = mean([e1, e2]);
% % % end
% % % % Left wrist
% % % err(end+1)  = error_internal(pose1.lowerLArmDistal, pose2.lowerLArmDistal);
% % % % Right shoulder
% % % err(end+1)  = error_internal(pose1.upperRArmProximal, pose2.upperRArmProximal);
% % % % Right elbow
% % % e1 = error_internal(pose1.upperRArmDistal, pose2.upperRArmDistal);
% % % e2 = error_internal(pose1.lowerRArmProximal, pose2.lowerRArmProximal);
% % % if (any([e1, e2]))
% % %     err(end+1) = mean([e1, e2]);
% % % end
% % % % Right wrist
% % % err(end+1)  = error_internal(pose1.lowerRArmDistal, pose2.lowerRArmDistal);
% % % % Left hip
% % % err(end+1)  = error_internal(pose1.upperLLegProximal, pose2.upperLLegProximal);
% % % % Left knee
% % % e1 = error_internal(pose1.upperLLegDistal, pose2.upperLLegDistal);
% % % e2 = error_internal(pose1.lowerLLegProximal, pose2.lowerLLegProximal);
% % % if (any([e1, e2]))
% % %     err(end+1) = mean([e1, e2]);
% % % end
% % % % Left ankle
% % % err(end+1)  = error_internal(pose1.lowerLLegDistal, pose2.lowerLLegDistal);
% % % % Right hip
% % % err(end+1)  = error_internal(pose1.upperRLegProximal, pose2.upperRLegProximal);
% % % % Right knee
% % % e1 = error_internal(pose1.upperRLegDistal, pose2.upperRLegDistal);
% % % e2 = error_internal(pose1.lowerRLegProximal, pose2.lowerRLegProximal);
% % % if (any([e1, e2]))
% % %     err(end+1) = mean([e1, e2]);
% % % end
% % % % Right ankle
% % % err(end+1)  = error_internal(pose1.lowerRLegDistal, pose2.lowerRLegDistal);
% % % % Head (top of the head)
% % % err(end+1)  = error_internal(pose1.headDistal, pose2.headDistal);
% % % err = mean(err);



