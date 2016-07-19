close all;
clear all;

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Uncut\tr\HDM_tr_5-3_a_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Uncut\tr\HDM_tr_5-3_b_120.amc';

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsLstart\HDM_mm_walk4StepsLstart_011_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsLstart\HDM_bk_walk4StepsLstart_005_120.amc'
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsLstart\HDM_mm_walk4StepsLstart_011_120.amc';
%range1 = [1:260];
%range2 = [1:260];

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\squat3Reps\HDM_mm_squat3Reps_010_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\squat3Reps\HDM_mm_squat3Reps_010_120.amc';
% range1 = [1:512];
% range2 = [1:512];

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpingJack3Reps\HDM_bd_jumpingJack3Reps_001_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpingJack3Reps\HDM_bd_jumpingJack3Reps_001_120.amc';
%range1 = [1:384];
%range2 = [1:384];

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\runOnPlaceStartFloor4StepsRStart\HDM_bd_runOnPlaceStartFloor4StepsRStart_001_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\runOnPlaceStartFloor4StepsRStart\HDM_bd_runOnPlaceStartFloor4StepsRStart_001_120.amc';
% range1 = [1:160];
% range2 = [1:160];

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jogRightCircle4StepsRstart\HDM_bk_jogRightCircle4StepsRstart_007_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jogRightCircle4StepsRstart\HDM_bk_jogRightCircle4StepsRstart_007_120.amc';
% range1 = [1:250];
% range2 = [1:250];

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\hopBothLegs3hops\HDM_mm_hopBothLegs3hops_011_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\hopBothLegs3hops\HDM_mm_hopBothLegs3hops_011_120.amc';
% range1 = [1:250];
% range2 = [1:250];

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\cartwheelLHandStart2Reps\HDM_tr_cartwheelLHandStart2Reps_001_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\cartwheelLHandStart2Reps\HDM_tr_cartwheelLHandStart2Reps_002_120.amc';
% range1 = [1:250];
% range2 = [1:250];

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walkRightCrossFront3Steps\HDM_tr_walkRightCrossFront3Steps_011_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walkRightCrossFront3Steps\HDM_tr_walkRightCrossFront3Steps_011_120.amc';
%range1 = [1:250];
%range2 = [1:250];

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpDown\HDM_mm_jumpDown_011_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpDown\HDM_tr_jumpDown_014_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\hopBothLegs1hops\HDM_dg_hopBothLegs1hops_023_120.amc';

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\sitDownChair\HDM_bd_sitDownChair_001_120.amc';
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\sitDownFloor\HDM_bd_sitDownFloor_001_120.amc';

%file1_fullpath = '
%file2_fullpath = '


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
downsampling_fac = 1;
rho = 0;
range1 = [];
range2 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename_prefix = '';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% good examples
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Uncut\mm\HDM_mm_3-5_c_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Uncut\mm\HDM_mm_3-5_d_120.amc';
% range1 = [525:660];
% range2 = [2530:2660];
% filename_prefix = 'mm_jumpingJack__mm_skierJack';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsLstart\HDM_mm_walk4StepsLstart_011_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsLstart\HDM_bk_walk4StepsLstart_005_120.amc'
% range1 = [1:260];
% range2 = [1:330];
% filename_prefix = 'mm_walk4Steps__bk_walk4Steps';

file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walkLeftCircle4StepsRstart\HDM_bd_walkLeftCircle4StepsRstart_003_120.amc';
file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsRstart\HDM_bd_walk4StepsRstart_001_120.amc'
range1 = [35:354];
%range2 = [1:330];
filename_prefix = 'bd_walkLeftCircle4Steps__bd_walk4Steps';

%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_bk_lieDownFloor_008_120.amc'; % quat cannot detect similarity during lying, while 3D can
%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_mm_lieDownFloor_015_120.amc';
%filename_prefix = 'bk_lieDownFloor__mm_lieDownFloor';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpingJack1Reps\HDM_dg_jumpingJack1Reps_028_120.amc'; % rho = 0, 2, 4
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\jumpingJack1Reps\HDM_tr_jumpingJack1Reps_047_120.amc';
% filename_prefix = 'dg_jumpingJack__tr_jumpingJack';

%file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\kickRSide2Reps\HDM_bd_kickRSide2Reps_003_120.amc';
%file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\kickRFront2Reps\HDM_bd_kickRFront2Reps_003_120.amc'; % schönes Beispiel relational/pointcloud versus quat!
%filename_prefix = 'bd_kickRSide__bd_kickRFront';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\cartwheelLHandStart1Reps\HDM_mm_cartwheelLHandStart1Reps_008_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\cartwheelLHandStart1Reps\HDM_mm_cartwheelLHandStart1Reps_009_120.amc';
% filename_prefix = 'mm_cartwheelLHandStart1Reps008__mm_cartwheelLHandStart1Reps009';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\staircaseUp3Rstart\HDM_mm_staircaseUp3Rstart_019_120.amc'; %3D does not work
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\walk4StepsRstart\HDM_mm_walk4StepsRstart_012_120.amc';      
% range1 = [1:230];
% range2 = [1:200];
% filename_prefix = 'mm_staircaseUp3Rstart__mm_walk3StepsRstart';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\rotateArmsBothBackward3Reps\HDM_bd_rotateArmsBothBackward3Reps_004_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\rotateArmsBothForward3Reps\HDM_bd_rotateArmsBothForward3Reps_004_120.amc';
% filename_prefix = 'bd_rotateArmsBothBackward3Reps__bd_rotateArmsBothForward3Reps';

% file1_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\rotateArmsBothForward3Reps\HDM_bd_rotateArmsBothForward3Reps_003_120.amc';
% file2_fullpath = 'S:\data_MoCap\MoCaDaDB\HDM\Training\rotateArmsBothForward3Reps\HDM_bd_rotateArmsBothForward3Reps_004_120.amc';
% filename_prefix = 'bd_rotateArmsBothForward3Reps__bd_rotateArmsBothForward3Reps';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute relational features from AMC/MAT files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load features_spec; 
[features1,fs1] = features_extract_single_file(file1_fullpath,features_spec,false);
[features2,fs2] = features_extract_single_file(file2_fullpath,features_spec,false);
nfeatures = length(features1);
nframes1 = size(features1{1},2);
nframes2 = size(features2{1},2);

if (isempty(range1))
    range1 = 1:nframes1;
end
if (isempty(range2))
    range2 = 1:nframes2;
end

% F1 = zeros(nfeatures,ceil(nframes1/downsampling_fac));
% F2 = zeros(nfeatures,ceil(nframes2/downsampling_fac));
F1 = zeros(nfeatures,nframes1);
F2 = zeros(nfeatures,nframes2);
for k=1:nfeatures
    F1(k,:) = features1{k};
    F2(k,:) = features2{k};
end
F1 = F1(:,range1(1):downsampling_fac:range1(end));
F2 = F2(:,range2(1):downsampling_fac:range2(end));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute relational feature distance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = nfeatures;
C_features = F1'*F2 + double(not(F1'))*double(not(F2));   %#(concurrences)
C_features = (p-C_features)/p; % #(disagreements per feature) (normalized by nfeatures!)
figure;
imagesc(C_features);
axis xy; axis equal; set(gca,'xlim',[1 size(C_features,2)],'ylim',[1 size(C_features,1)]);
colormap hot; colorbar;
set(gcf,'name',[filename_prefix ' C_{relational}']);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_C_rel_' num2str(fs1) '.fig']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load angle and 3D trajectory data from AMC/MAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[skel1,mot1]=readMocap(file1_fullpath,file1_fullpath,[],1,1);
[skel2,mot2]=readMocap(file2_fullpath,file2_fullpath,[],1,1);
mot1 = cropMot(mot1,range1);
mot2 = cropMot(mot2,range2);
mot1 = integerDownsampleMot(mot1,downsampling_fac);
mot2 = integerDownsampleMot(mot2,downsampling_fac);
%mot2 = rotateMotY_absolute(skel2,mot2,pi/4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute quaternion distance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

joints = {'lhip','lknee','lankle','rhip','rknee','rankle','belly','chest','neck','head','lshoulder','lelbow','rshoulder','relbow'};
%w      = [  0       0        0       0      0       0        0       0       0      0        1          0       1           0];
%w      = [  0       0        0       0      0       0        1       1       1      1        1          1       1           1];
%w      = [  1       0        0       1      0       0        0       0       0      0        1          0       1           0];
%w      = [  0       0        0       0      0       0        0       0       0      0        1          0       1           0];
w = ones(1,length(joints));
%w      = [  1       0.5     0.25    1       0.5     0.25     1       1      0.5    0.25      1          0.5       1          0.5];
w = w/sum(w);

P = mot2matrix(mot1,skel1,'quat',joints);   % extract quaternions for certain joints from motion data structure
Q = mot2matrix(mot2,skel2,'quat',joints);

C_quat = distMatrix_quaternionDistance(P,Q,1,'geodesic',w); 

figure;
imagesc(C_quat);
axis xy; axis equal; set(gca,'xlim',[1 size(C_quat,2)],'ylim',[1 size(C_quat,1)]);
colormap hot; colorbar;
set(gcf,'name',[filename_prefix ' C_{quat}']);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_C_quat_' num2str(mot1.samplingRate) '.fig']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute point cloud distance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[C_pointcloud,theta,x0,z0,xt,zt] = distMatrix_pointCloudDistance(mot1.jointTrajectories,mot2.jointTrajectories,1,rho,false); 
figure;
imagesc(C_pointcloud);
colormap hot; colorbar;
axis xy; axis equal; set(gca,'xlim',[1 size(C_pointcloud,2)],'ylim',[1 size(C_pointcloud,1)]);
%t = get(gca,'xticklabel'); set(gca,'xticklabel',num2str(downsampling_fac*str2num(t))); t = get(gca,'yticklabel'); set(gca,'yticklabel',num2str(downsampling_fac*str2num(t)));
set(gcf,'name',[filename_prefix ' C_{3D}, \rho=' num2str(rho)]);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_C_3D_rho_' num2str(rho) '_' num2str(mot1.samplingRate) '.fig']);
end

figure;
imagesc(theta*180/pi);
colormap([flipud(bone); hot]); colorbar;
axis xy; axis equal; set(gca,'xlim',[1 size(C_pointcloud,2)],'ylim',[1 size(C_pointcloud,1)]);
set(gcf,'name',[filename_prefix ' \theta [°]: rotation of second pose about its centroid']);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_theta_' num2str(mot1.samplingRate) '.fig']);
end

figure;
imagesc(xt);
colormap([flipud(bone); copper]); colorbar;
axis xy; axis equal; set(gca,'xlim',[1 size(C_pointcloud,2)],'ylim',[1 size(C_pointcloud,1)]);
set(gcf,'name',[filename_prefix ' x_t: translation of second pose''s centroid in x direction']);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_x0_' num2str(mot1.samplingRate) '.fig']);
end

figure;
imagesc(zt);
colormap([flipud(bone); copper]); colorbar;
axis xy; axis equal; set(gca,'xlim',[1 size(C_pointcloud,2)],'ylim',[1 size(C_pointcloud,1)]);
set(gcf,'name',[filename_prefix ' z_t: translation of second pose''s centroid in z direction']);
if (~isempty(filename_prefix))
    saveas(gcf,['print/' filename_prefix '_z0_' num2str(mot1.samplingRate) '.fig']);
end
