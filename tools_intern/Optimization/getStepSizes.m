% function getStepSizes
% (naively) computes stepSizes for walking motions
% stepSizes = getStepSizes(skel,mot)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function [stepSizesMin,stepSizesMax] = getStepSizes(mot)

leftJoint   = 4;
rightJoint  = 9;

% for i=1:mot.nframes-1
%     if     ((mot.jointTrajectories{leftJoint}(2,i)<=mot.jointTrajectories{rightJoint}(2,i))...
%         && (mot.jointTrajectories{leftJoint}(2,i+1)>mot.jointTrajectories{rightJoint}(2,i+1)))...
%         || ((mot.jointTrajectories{leftJoint}(2,i)>=mot.jointTrajectories{rightJoint}(2,i))...
%         && (mot.jointTrajectories{leftJoint}(2,i+1)<mot.jointTrajectories{rightJoint}(2,i+1)))
%     
%         counter=counter+1;
%         stepSizes(counter)=normOfColumns(mot.jointTrajectories{5}(:,i)-mot.jointTrajectories{10}(:,i));
%         
%     elseif     ((i==mot.nframes-1)...
%             && (mot.jointTrajectories{leftJoint}(2,i+1)==mot.jointTrajectories{rightJoint}(2,i+1)))
%         
%         counter=counter+1;
%         stepSizes(counter)=normOfColumns(mot.jointTrajectories{5}(:,i+1)-mot.jointTrajectories{10}(:,i+1));
%     end
% end

leftToRight=findstr([0 sign((mot.jointTrajectories{leftJoint}(2,:))-(mot.jointTrajectories{rightJoint}(2,:)))],[-1 1]);
rightToLeft=findstr([0 sign((mot.jointTrajectories{rightJoint}(2,:))-(mot.jointTrajectories{leftJoint}(2,:)))],[-1 1]);
frameIDs=union(1,[leftToRight,rightToLeft,mot.nframes]);

if mot.jointTrajectories{leftJoint}(2,1)<=mot.jointTrajectories{rightJoint}(2,1) % left foot on floor in first frame
    joints=[leftJoint rightJoint];
else
    joints=[rightJoint leftJoint];
end

maxPositions    = zeros(1,length(frameIDs)-1);
minPositions    = zeros(1,length(frameIDs)-1);
maxValues       = zeros(3,length(frameIDs)-1);
minValues       = zeros(3,length(frameIDs)-1);

for i=2:length(frameIDs)
    [minValue,minPos]=min(mot.jointTrajectories{joints(1)}(2,frameIDs(i-1):frameIDs(i)));
    [maxValue,maxPos]=max(mot.jointTrajectories{joints(2)}(2,frameIDs(i-1):frameIDs(i)));
    maxPositions(i-1)=maxPos+frameIDs(i-1)-1;
    minPositions(i-1)=minPos+frameIDs(i-1)-1;
    minValues(:,i-1)=mot.jointTrajectories{joints(1)}(:,minPositions(i-1));
    maxValues(:,i-1)=mot.jointTrajectories{joints(1)}(:,maxPositions(i-1)); % joints(1) is correct!
    joints=fliplr(joints);
end

stepSizesMin = zeros(1,length(minValues)-1);
stepSizesMax = zeros(1,length(maxValues)-1);

for i=2:length(minValues)
    stepSizesMin(i-1)=normOfColumns(minValues(:,i)-minValues(:,i-1));
end
for i=2:length(maxValues)
    stepSizesMax(i-1)=normOfColumns(maxValues(:,i)-maxValues(:,i-1));
end

% lastOnFloor='';
% counter=0;
% minID=0;
% coordinates=[];
% 
% for i=1:mot.nframes
%     if mot.jointTrajectories{leftJoint}(2,i)<=mot.jointTrajectories{rightJoint}(2,i) % left foot on floor
%         if ~strcmp(lastOnFloor,'left')
%             counter=counter+1;
%             minSoFar=inf;
%             if minID~=0
%                 if ~isempty(coordinates)
%                     stepSizes(counter)=normOfColumns(coordinates-mot.jointTrajectories{rightJoint}(:,minID));
%                 end
%                 coordinates=mot.jointTrajectories{rightJoint}(:,minID);
%             end
%         end
%         if mot.jointTrajectories{leftJoint}(2,i)<minSoFar
%             minSoFar=mot.jointTrajectories{leftJoint}(2,i);
%             minID=i;
%         end
%         lastOnFloor='left';
%     else % right foot on Floor
%         if ~strcmp(lastOnFloor,'right')
%             counter=counter+1;
%             minSoFar=inf;
%             if minID~=0
%                 if ~isempty(coordinates)
%                     stepSizes(counter)=normOfColumns(coordinates-mot.jointTrajectories{leftJoint}(:,minID));
%                 end
%                 coordinates=mot.jointTrajectories{leftJoint}(:,minID);
%             end
%         end
%         if mot.jointTrajectories{rightJoint}(2,i)<minSoFar
%             minSoFar=mot.jointTrajectories{rightJoint}(2,i);
%             minID=i;
%         end
%         lastOnFloor='right';
%     end
% end
