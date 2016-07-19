% [skelPC,motPC]=readMocap('..\parser\testdata\CMU_02_01.c3d','',[],0,0);
% [skel,mot]=readMocap('..\parser\testdata\CMU_02_01.c3d','',[],0,1);
%[skel,mot]=readMocap('..\parser\testdata\CMU_02.asf','..\parser\testdata\CMU_02_01.amc');
%[skel,mot]=readMocap('..\..\parser\testdata\HDM_tr.asf','parser\testdata\HDM_5_3aTR.amc');
%[skelPC,motPC]=readMocap('S:\data_MoCap\HDM\HDM_clean\tr\c3d\HDM_tr_05-03_01_120.c3d','',[],0,0);
%[skel,mot]=readMocap('S:\data_MoCap\HDM\HDM_clean\tr\c3d\HDM_tr_05-03_01_120.c3d','',[],0,1);

%[skel,mot] = readMocapD(143);
%[skel1,mot1]=readMocap('S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr.asf','S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr_lieDownFloor_019_120.amc',[],0,1);
%[skel2,mot2]=readMocap('S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr.asf','S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr_lieDownFloor_020_120.amc',[],0,1);

%[skel1,mot1]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_01_120.amc',[],1,1);
%[skel2,mot2]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_02_120.amc',[],1,1);

% [skel1,mot1]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_01_120.amc',[946*6 956*6],1,1);
% [skel2,mot2]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_02_120.amc',[832*6 842*6],1,1);

close all;

downsampling_fac = 6;

joints = {'lhip','lknee','lankle','rhip','rknee','rankle','belly','chest','neck','head','lshoulder','lelbow','rshoulder','relbow'};
w      = [  0       0        0       0      0       0        0       0       0      0        1          0       1           0];
%w      = [  1       0.5     0.25    1       0.5     0.25     1       1      0.5    0.25      1          0.5       1          0.5];
w = w/sum(w);

%joints = {'lknee'};
%w = 1;

P = mot2matrix(mot1,skel1,'quat',joints); 
Q = mot2matrix(mot2,skel2,'quat',joints);

C = distMatrix_quaternionDistance(P,Q,downsampling_fac,'geodesic',w);

figure;
imagesc(C);
axis xy; axis equal; set(gca,'xlim',[1 size(C,2)],'ylim',[1 size(C,1)]);
colormap hot; colorbar;