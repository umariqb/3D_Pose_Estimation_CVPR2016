function compareJointTrajectories( mot1, mot2, jointName, showDist, lineWidth )
% compareJointTrajectories( mot1, mot2, jointName, showDist, lineWidth )

if nargin < 1   % demo mode :)
    disp('demo mode :)');
    global VARS_GLOBAL
    [skel1, mot1] = readMocapSmartLCS(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_amc', 'turnRight', 'HDM_tr_turnRight_026_120.amc'));
    [skel2, mot2] = readMocapSmartLCS(fullfile(VARS_GLOBAL.dir_root, 'HDM05_cut_c3d', 'turnRight', 'HDM_tr_turnRight_026_120.c3d'), true);
    jointName = 'rtoes';
end

if nargin < 4
    showDist = true;
end

if nargin < 5
    lineWidth = 1;
end
    
if mot1.nframes ~= mot2.nframes
    error('Files have different number of frames and cannot be compared!');
end

jointID1 = trajectoryID(mot1, jointName);
jointID2 = trajectoryID(mot2, jointName);

figure;
hold on;

plot3(mot1.jointTrajectories{jointID1}(1,:), mot1.jointTrajectories{jointID1}(2,:), mot1.jointTrajectories{jointID1}(3,:), 'b');
plot3(mot2.jointTrajectories{jointID2}(1,:), mot2.jointTrajectories{jointID2}(2,:), mot2.jointTrajectories{jointID2}(3,:), 'r');
ch=get(gca, 'children');
set(ch(1), 'linewidth', lineWidth);
set(ch(2), 'linewidth', lineWidth);
     
if showDist
    nrLines = 100;
    step = floor(mot1.nframes / nrLines);
    step = max(step, 1);
    
    for i=1:step:mot1.nframes
        p1 = mot1.jointTrajectories{jointID1}(:,i);
        p2 = mot2.jointTrajectories{jointID2}(:,i);
        
        h=line([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)]);
        set(h, 'color', [1 0.8 0.2]);
        set(h, 'linewidth', lineWidth - 0.5);
    end
end