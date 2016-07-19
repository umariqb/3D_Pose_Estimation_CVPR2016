recalc = true;

motFile = 'HDM_bd_punchRFront2Reps_003_120.C3D';
info = filename2info(motFile);
dirDB = VARS_GLOBAL.dir_root;
[skelC3Dgen, motC3Dgen] = readMocapSmart(fullfile(VARS_GLOBAL.dir_root, 'hdm05_cut_c3d', info.motionCategory, motFile));
[skelC3D, motC3D] = readMocapSmart(fullfile(VARS_GLOBAL.dir_root, 'hdm05_cut_c3d', info.motionCategory, motFile), false);
[skelAMC, motAMC] = readMocapSmart(fullfile(VARS_GLOBAL.dir_root, 'hdm05_cut_amc', info.motionCategory, [motFile(1:end-3) 'AMC']));

if recalc
    jointPosCalc1 = estimateJointPos(motC3D, {'RWRA', 'RWRB', 'RFRM'}, {'RELB', 'RUPA', 'RSHO'}, 1);
    jointPosCalc2 = estimateJointPos(motC3D, {'RWRA', 'RWRB', 'RFRM'}, {'RELB', 'RUPA', 'RSHO'}, 2);
    jointPosCalc3 = estimateJointPos(motC3D, {'RWRA', 'RWRB', 'RFRM'}, {'RELB', 'RUPA', 'RSHO'}, 3);
    jointPosCalc4 = estimateJointPos(motC3D, {'RWRA', 'RWRB', 'RFRM'}, {'RELB', 'RUPA', 'RSHO'}, 4);
    
    save jointPosCalc1 jointPosCalc1
    save jointPosCalc2 jointPosCalc2
    save jointPosCalc3 jointPosCalc3
    save jointPosCalc4 jointPosCalc4
else
    load jointPosCalc1
    load jointPosCalc2
    load jointPosCalc3
    load jointPosCalc4
end

jointPosC3D = motC3Dgen.jointTrajectories{trajectoryID(motC3Dgen, 'relbow')};
jointPosAMC = motAMC.jointTrajectories{trajectoryID(motAMC, 'relbow')};

diffC3D1 = sqrt(dot(jointPosC3D - jointPosCalc1, jointPosC3D - jointPosCalc1));
diffAMC1 = sqrt(dot(jointPosAMC - jointPosCalc1, jointPosAMC - jointPosCalc1));
diffC3D2 = sqrt(dot(jointPosC3D - jointPosCalc2, jointPosC3D - jointPosCalc2));
diffAMC2 = sqrt(dot(jointPosAMC - jointPosCalc2, jointPosAMC - jointPosCalc2));
diffC3D3 = sqrt(dot(jointPosC3D - jointPosCalc3, jointPosC3D - jointPosCalc3));
diffAMC3 = sqrt(dot(jointPosAMC - jointPosCalc3, jointPosAMC - jointPosCalc3));
diffC3D4 = sqrt(dot(jointPosC3D - jointPosCalc4, jointPosC3D - jointPosCalc4));
diffAMC4 = sqrt(dot(jointPosAMC - jointPosCalc4, jointPosAMC - jointPosCalc4));

figure;
plot([1:motC3D.nframes], diffC3D1, [1:motC3D.nframes], diffAMC1);
legend('calc vs. C3D', 'calc vs. AMC');
title('method 1');
figure;
plot([1:motC3D.nframes], diffC3D2, [1:motC3D.nframes], diffAMC2);
legend('calc vs. C3D', 'calc vs. AMC');
title('method 2');
figure;
plot([1:motC3D.nframes], diffC3D3, [1:motC3D.nframes], diffAMC3);
legend('calc vs. C3D', 'calc vs. AMC');
title('method 3');
figure;
plot([1:motC3D.nframes], diffC3D4, [1:motC3D.nframes], diffAMC4);
legend('calc vs. C3D', 'calc vs. AMC');
title('method 4');

motCalc1 = motC3Dgen;
motCalc1.jointTrajectories{trajectoryID(motC3Dgen, 'relbow')} = jointPosCalc1;
motCalc2 = motC3Dgen;
motCalc2.jointTrajectories{trajectoryID(motC3Dgen, 'relbow')} = jointPosCalc2;
motCalc3 = motC3Dgen;
motCalc3.jointTrajectories{trajectoryID(motC3Dgen, 'relbow')} = jointPosCalc3;
motCalc4 = motC3Dgen;
motCalc4.jointTrajectories{trajectoryID(motC3Dgen, 'relbow')} = jointPosCalc4;
% animate(skelC3Dgen, motCalc, 1, 0.2);
% animate([skelC3Dgen skelC3Dgen], [motCalc motC3Dgen], 1, 0.2);
% animate([skelC3Dgen skelAMC], [motCalc motAMC], 1, 0.2);