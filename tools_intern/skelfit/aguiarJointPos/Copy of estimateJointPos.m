function jointPos = estimateJointPos( mot, markerGroup1, markerGroup2, method )
%   estimateJointPos( mot, markerGroup1, markerGroup2 )
%
%       mot:          motion file (read by readMocap)
%       markerGroup1: Markers of first limb (min. 3)
%       markerGroup2: Markers of first limb (min. 3)

if nargin < 4
    method = 1;
end
% frameRange = [350];
% frameRange = [70];
frameRange = [1:mot.nframes];
refFrames = [2 ones(1, mot.nframes-1)];


warning off
disp('frame  ');

% % test = true;
% test = false;
% if test
%     markerGroup1CoordsF2 = [ 20 40 30; -10 20 40; -30 -50 -60];
%     A_toget = buildRotMatrixXYZ( pi/4, 0, pi/3 );
%     t_toget = [10; 8; -20];
%     markerGroup1CoordsF1 = A_toget * markerGroup1CoordsF2 + [t_toget t_toget t_toget];
% end

global VARS_GLOBAL;
VARS_GLOBAL.getRotationLastResult = [];
VARS_GLOBAL.getRotation_devPenalties = [];
VARS_GLOBAL.getRotation_distCosts = [];
VARS_GLOBAL.getRotation_angleCosts = [];
lastResult = [];

for i=1:length(frameRange)

    markerGroup1CoordsF2 = []; 
    for j=1:length(markerGroup1)
        idx = trajectoryID(mot, markerGroup1{j});
        markerGroup1CoordsF1(:,j) = mot.jointTrajectories{idx}(:,refFrames(i));
        markerGroup1CoordsF2(:,j) = mot.jointTrajectories{idx}(:,frameRange(i));
    end

    % determine transformation from one frame to another for markerGroup1
    switch method
        case 1
            [A, t, residuum] = getTransformation(markerGroup1CoordsF2, markerGroup1CoordsF1);
        case 2
            [A, t, residuum] = getTransformation2(markerGroup1CoordsF2, markerGroup1CoordsF1);
        case 3
            startValue = [0 0 0 [0 0 0]];
            LB = []; UB = []; 
            OPTIONS = optimset('Diagnostics', 'off', 'Display', 'off');
            x = LSQNONLIN(@estimateJointPos_costFunTrans, startValue, LB,UB,OPTIONS, markerGroup1CoordsF2, markerGroup1CoordsF1, method);
            A = buildRotMatrix( [ cos(x(1)); cos(x(2)); sin(x(1))], x(3));
            t = x(4:6)';
            residuum = A*markerGroup1CoordsF2 + [t t t] - markerGroup1CoordsF1;
        case 4  
            startValue = [0 0 0 0 [0 0 0]];
            LB = [0 0 0 0 -500 -500 -500]; UB = [1 1 1 2*pi 500 500 500]; 
            OPTIONS = optimset('Diagnostics', 'off', 'Display', 'off');
            A = [];
            B = [];
            
            x = FMINCON(@estimateJointPos_costFunTrans, startValue, A, B, [], [] , LB, UB, [], OPTIONS, markerGroup1CoordsF2, markerGroup1CoordsF1, method);
            A = buildRotMatrix( [ x(1), x(2), x(3) ], x(4));
            t = x(5:7)';
            residuum = A*markerGroup1CoordsF2 + [t t t] - markerGroup1CoordsF1;
        case 5
%             if length(markerGroup1) ~= 3 || length(markerGroup2) ~= 3 
%                 error('Sorry, only works for marker groups of size 3!');
%             end
            if i==96
                disp('');
            end
            A = getRotation( markerGroup1CoordsF2, markerGroup1CoordsF1);
            centerOfGravity1 = mean(markerGroup1CoordsF1,2);
            centerOfGravity2 = mean(A*markerGroup1CoordsF2,2);
            t = centerOfGravity1 - centerOfGravity2;

    end
%     disp(residuum);
    disp([repmat(char(8),1,length(num2str(i-1))+1) num2str(frameRange(i))]);
    %     disp(['frame ' num2str(i)]);
    
    for j=1:length(markerGroup2)
        idx = trajectoryID(mot, markerGroup2{j});
        markerGroup2CoordsF1(:,j) = mot.jointTrajectories{idx}(:,refFrames(i));
        markerGroup2CoordsF2(:,j) = mot.jointTrajectories{idx}(:,frameRange(i));
    end
    % apply transformation to markerGroup2 to "align" frames
%     if method == 5
%         markerGroup1CoordsF2_trans = A * (markerGroup1CoordsF2 + [t t t]);
%         markerGroup2CoordsF2_trans = A * (markerGroup1CoordsF2 - [centerOfGravity2 centerOfGravity2 centerOfGravity2]) ...
%             + [centerOfGravity2 centerOfGravity2 centerOfGravity2] + [t t t];
%     else
        markerGroup1CoordsF2_trans = A * markerGroup1CoordsF2 + repmat(t, 1, size(markerGroup1CoordsF2, 2));
        markerGroup2CoordsF2_trans = A * markerGroup2CoordsF2 + repmat(t, 1, size(markerGroup2CoordsF2, 2));
%     end
    
    startValue = markerGroup2CoordsF1(:,1);
    LB = []; UB = []; 
    OPTIONS = optimset('Diagnostics', 'off', 'Display', 'off');
    jP = LSQNONLIN(@estimateJointPos_costFunRotCenter, startValue, LB,UB,OPTIONS, markerGroup1CoordsF1, markerGroup2CoordsF1, markerGroup1CoordsF2_trans, markerGroup2CoordsF2_trans, lastResult);
    jointPos(:,i) = A^-1*(jP - t);
    
    lastResult = jP;
    
    if length(frameRange)==1
        figure;
        hold on
        %dots
        plot3(markerGroup1CoordsF1(1,:),markerGroup1CoordsF1(2,:),markerGroup1CoordsF1(3,:), 'bx');
        plot3(markerGroup2CoordsF1(1,:),markerGroup2CoordsF1(2,:),markerGroup2CoordsF1(3,:), 'bo');
        
        plot3(markerGroup1CoordsF2_trans(1,:),markerGroup1CoordsF2_trans(2,:),markerGroup1CoordsF2_trans(3,:), 'gx');
        plot3(markerGroup2CoordsF2_trans(1,:),markerGroup2CoordsF2_trans(2,:),markerGroup2CoordsF2_trans(3,:), 'go');
                
        plot3(markerGroup1CoordsF2(1,:),markerGroup1CoordsF2(2,:),markerGroup1CoordsF2(3,:), 'rx');
        plot3(markerGroup2CoordsF2(1,:),markerGroup2CoordsF2(2,:),markerGroup2CoordsF2(3,:), 'ro');
        
        %lines
        plot3(markerGroup1CoordsF1(1,:),markerGroup1CoordsF1(2,:),markerGroup1CoordsF1(3,:), 'b');
        plot3(markerGroup2CoordsF1(1,:),markerGroup2CoordsF1(2,:),markerGroup2CoordsF1(3,:), 'b');
        
        plot3(markerGroup1CoordsF2_trans(1,:),markerGroup1CoordsF2_trans(2,:),markerGroup1CoordsF2_trans(3,:), 'g');
        plot3(markerGroup2CoordsF2_trans(1,:),markerGroup2CoordsF2_trans(2,:),markerGroup2CoordsF2_trans(3,:), 'g');
        
        plot3(markerGroup1CoordsF2(1,:),markerGroup1CoordsF2(2,:),markerGroup1CoordsF2(3,:), 'r');
        plot3(markerGroup2CoordsF2(1,:),markerGroup2CoordsF2(2,:),markerGroup2CoordsF2(3,:), 'r');
        
        legend('m1, fr1', 'm2, fr1', 'm1, trans 2->1', 'm2, trans 2->1', 'm1, fr2', 'm2, fr2');
        %         plot3(middle(1,:), middle(2,:), middle(3,:), 'kx');
        
        plot3(jointPos(1,i), jointPos(2,i), jointPos(3,i), 'ks');
        plot3(jP(1), jP(2), jP(3), 'kd');
    end
end

warning on