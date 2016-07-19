% 
penalties = [0.1 0.5 1 1.5 2 3 5 10];
% penalties = [1:5];

[skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\rotateArmsBothBackward1Reps\HDM_bk_rotateArmsBothBackward1Reps_008_120.c3d', false, false);
[skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\rotateArmsBothBackward1Reps\HDM_bk_rotateArmsBothBackward1Reps_008_120.c3d');

markerGroup1 = {'RFRM', 'RWRA', 'RWRB'};
markerGroup2 = {'RSHO', 'RUPA', 'RELB'};

for i=penalties
    VARS_GLOBAL.estimateJointPos_costFunRotCenter_devPenaltyWeight = i;

    motC3Dgen5 = motC3Dgen;
    motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 5);
    compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen5, 'relbow');
end

VARS_GLOBAL.estimateJointPos_costFunRotCenter_devPenaltyWeight = [];