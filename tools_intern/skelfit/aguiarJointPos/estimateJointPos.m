function jointPos = estimateJointPos( mot, markerGroup1, markerGroup2 )
%   estimateJointPos( mot, markerGroup1, markerGroup2 )
%
%       mot:          motion file (read by readMocap)
%       markerGroup1: Markers of first limb (min. 3)
%       markerGroup2: Markers of first limb (min. 3)

if nargin < 4
    method = 1;
end
% frameRange = [70];
% frameRange = [1:10:100];
% frameRange = [1:100];
frameRange = [1:mot.nframes];
refFrame = 1;


warning off
disp('frame ');

global VARS_GLOBAL;
VARS_GLOBAL.getRotationLastResult = [];
VARS_GLOBAL.getRotation_devPenalties = [];
VARS_GLOBAL.getRotation_distCosts = [];
VARS_GLOBAL.getRotation_angleCosts = [];
lastResult = [];

for j=1:length(markerGroup1)
    idx = trajectoryID(mot, markerGroup1{j});
    markerGroup1CoordsF1(:,j) = mot.jointTrajectories{idx}(:,refFrame);
end

for i=1:length(frameRange)
    
    markerGroup1CoordsF2 = []; 
    for j=1:length(markerGroup1)
        idx = trajectoryID(mot, markerGroup1{j});
        markerGroup1CoordsF2(:,j) = mot.jointTrajectories{idx}(:,frameRange(i));
    end
    
    %             if length(markerGroup1) ~= 3 || length(markerGroup2) ~= 3 
    %                 error('Sorry, only works for marker groups of size 3!');
    %             end
    A{i} = getRotation( markerGroup1CoordsF2, markerGroup1CoordsF1);
%     A{i} = getRotation2( markerGroup1CoordsF2, markerGroup1CoordsF1);
    centerOfGravity1 = mean(markerGroup1CoordsF1,2);
    centerOfGravity2 = mean(A{i}*markerGroup1CoordsF2,2);
    t{i} = centerOfGravity1 - centerOfGravity2;
            
    if i==1
        disp( [char(8) num2str(frameRange(i))] );
    else
        disp([repmat(char(8),1,length(num2str(frameRange(i-1)))+1) num2str(frameRange(i))]);
    end
end

markers = [markerGroup1, markerGroup2];
for i=1:length(markers)
    idx = trajectoryID(mot, markers{i});
    traj{i} = mot.jointTrajectories{idx};
    for j=1:length(A)
        markerCoords{i}(:,j) = A{j}*traj{i}(:,j) + t{j};
    end
end

startValue = markerCoords{1}(:,1);
LB = []; UB = []; 
OPTIONS = optimset('Diagnostics', 'off', 'Display', 'off');
jointPosRef = LSQNONLIN(@estimateJointPos_costFunRotCenter, startValue, LB,UB,OPTIONS, markerCoords, lastResult);

for i=1:length(A)
    jointPos(:,i) = A{i}^-1*(jointPosRef - t{i});
end

colors = {'c', 'b', 'g', 'r', 'm', ' k'};
figure;
hold on
for i=1:min(length(frameRange), 8)
    color = colors{ mod(i, length(colors)) + 1 };
    for j=1:length(markerCoords)
        %             toPlot(:,j) = markerCoords{j}(:,i)
        plot3(markerCoords{j}(1,i), markerCoords{j}(2,i), markerCoords{j}(3,i), [color 'o']);
%         plot3(traj{j}(1,i), traj{j}(2,i), traj{j}(3,i), [color 'x']);
        if i==1
            text(markerCoords{j}(1,i), markerCoords{j}(2,i), markerCoords{j}(3,i), markers{j});
        end
    end
    %         plot3(toPlot(1,:), toPlot(2,:), toPlot(3,:), color); 
    plot3(jointPos(1,i), jointPos(2,i), jointPos(3,i), [color 's']);
end


warning on