% [skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\rotateArmsBothBackward1Reps\HDM_bk_rotateArmsBothBackward1Reps_008_120.c3d', false, false);
% [skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\rotateArmsBothBackward1Reps\HDM_bk_rotateArmsBothBackward1Reps_008_120.c3d');
% [skelAMC, motAMC] = readMocapSmart('D:\Uni\HDM05\HDM05_cut_amc\rotateArmsBothBackward1Reps\HDM_bk_rotateArmsBothBackward1Reps_008_120.amc');
% 
% [skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\elbowToKnee3RepsLelbowStart\HDM_tr_elbowToKnee3RepsLelbowStart_013_120.C3D', false, false);
% [skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_cut_c3d\elbowToKnee3RepsLelbowStart\HDM_tr_elbowToKnee3RepsLelbowStart_013_120.C3D');
% [skelAMC, motAMC] = readMocapSmart('D:\Uni\HDM05\HDM05_cut_amc\elbowToKnee3RepsLelbowStart\HDM_tr_elbowToKnee3RepsLelbowStart_013_120.amc');

[skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_c3d\mm\HDM_mm_01-02_02_120.c3d', false, false);
[skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_c3d\mm\HDM_mm_01-02_02_120.c3d');
[skelAMC, motAMC] = readMocapSmart('D:\Uni\HDM05\HDM05_amc\mm\HDM_mm_01-02_02_120.amc');

% [skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_c3d\tr\HDM_tr_01-01_01_120.c3d', false, false);
% [skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_c3d\tr\HDM_tr_01-01_01_120.c3d');
% [skelAMC, motAMC] = readMocapSmart('D:\Uni\HDM05\HDM05_amc\tr\HDM_tr_01-01_01_120.amc');

% [skelC3D, motC3D] = readMocap('D:\Uni\HDM05\HDM05_c3d\tr\HDM_tr_03-05_02_120.c3d', false, false);
% [skelC3Dgen, motC3Dgen] = readMocap('D:\Uni\HDM05\HDM05_c3d\tr\HDM_tr_03-05_02_120.c3d');
% [skelAMC, motAMC] = readMocapSmart('D:\Uni\HDM05\HDM05_amc\tr\HDM_tr_03-05_02_120.amc');

% motC3Dgen1 = motC3Dgen;
% motC3Dgen2 = motC3Dgen;
% motC3Dgen3 = motC3Dgen;
% motC3Dgen4 = motC3Dgen;
motC3Dgen5 = motC3Dgen;
tic;
markerGroup1 = {'C7', 'CLAV', 'RBAC'};
markerGroup2 = {'RSHO', 'RUPA', 'RELB'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'rshoulder')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

markerGroup1 = {'RFRM', 'RWRA', 'RWRB'};
markerGroup2 = {'RSHO', 'RUPA', 'RELB'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

markerGroup1 = {'RFWT', 'RBWT', 'LFWT' };
markerGroup2 = {'RTHI', 'RKNE'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'rhip')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

toc;

markerGroup1 = {'C7', 'CLAV', 'RBAC'};
markerGroup2 = {'LSHO', 'LUPA', 'LELB'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'lshoulder')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

markerGroup1 = {'LFRM', 'LWRA', 'LWRB'};
markerGroup2 = {'LSHO', 'LUPA', 'LELB'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'lelbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

markerGroup1 = {'LFWT', 'LBWT', 'LFWT' };
markerGroup2 = {'LTHI', 'LKNE'};
motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'lhip')} = estimateJointPos(motC3D, markerGroup1, markerGroup2);

% motC3Dgen1.jointTrajectories{trajectoryID(motC3Dgen1, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 1);
% motC3Dgen2.jointTrajectories{trajectoryID(motC3Dgen2, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 2);
% motC3Dgen3.jointTrajectories{trajectoryID(motC3Dgen3, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 3);
% motC3Dgen4.jointTrajectories{trajectoryID(motC3Dgen4, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 4);
% motC3Dgen5.jointTrajectories{trajectoryID(motC3Dgen5, 'relbow')} = estimateJointPos(motC3D, markerGroup1, markerGroup2, 5);

% compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen1, 'relbow');
% compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen2, 'relbow');
% compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen3, 'relbow');
% compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen4, 'relbow');
% compareJoint(skelC3Dgen, motC3Dgen, skelC3Dgen, motC3Dgen5, 'relbow');

