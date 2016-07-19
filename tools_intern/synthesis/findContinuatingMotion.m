function res=findContinuatingMotion(skel,query,DB)

%% Start time measurement
tic;

%% retrieval step


%% selection step



%% Test: Random select:
nr=ceil(9.*rand(1));
if (nr==1) load('R:\HDM05_MediumDB\cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_001_120.amc.MAT');end
if (nr==2) load('R:\HDM05_MediumDB\cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_002_120.amc.MAT');end
if (nr==3) load('R:\HDM05_MediumDB\cut_amc\cartwheelLHandStart1Reps\HDM_bd_cartwheelLHandStart1Reps_003_120.amc.MAT');end
if (nr==4) load('R:\HDM05_MediumDB\cut_amc\jumpingJack1Reps\HDM_bd_jumpingJack1Reps_001_120.amc.MAT');end
if (nr==5) load('R:\HDM05_MediumDB\cut_amc\jumpingJack1Reps\HDM_bd_jumpingJack1Reps_002_120.amc.MAT');end
if (nr==6) load('R:\HDM05_MediumDB\cut_amc\jumpingJack1Reps\HDM_bd_jumpingJack1Reps_003_120.amc.MAT');end
if (nr==7) load('R:\HDM05_MediumDB\cut_amc\rotateArmsBothForward1Reps\HDM_bd_rotateArmsBothForward1Reps_001_120.amc.MAT');end
if (nr==8) load('R:\HDM05_MediumDB\cut_amc\rotateArmsLForward1Reps\HDM_bd_rotateArmsLForward1Reps_002_120.amc.MAT');end
if (nr==9) load('R:\HDM05_MediumDB\cut_amc\kickLSide1Reps\HDM_bd_kickLSide1Reps_001_120.amc.MAT');end
res=mot;

%% Stop time measurement and print result:
time=toc;
disp(['Found continuating motion in:   ' num2str(time) ' seconds']);