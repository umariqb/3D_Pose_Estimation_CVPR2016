% [skelPC,motPC]=readMocap('..\parser\testdata\CMU_02_01.c3d','',[],0,0);
% [skel,mot]=readMocap('..\parser\testdata\CMU_02_01.c3d','',[],0,1);
%[skelPC,motPC]=readMocap('S:\data_MoCap\HDM\HDM_clean\tr\c3d\HDM_tr_05-03_01_120.c3d','',[],0,0);
%[skel,mot]=readMocap('S:\data_MoCap\HDM\HDM_clean\tr\c3d\HDM_tr_05-03_01_120.c3d','',[],0,1);

%[skel,mot] = readMocapD(143);
%[skel1,mot1]=readMocap('S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr.asd','S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr_lieDownFloor_019_120.amc',[],0,1);
%[skel2,mot2]=readMocap('S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_bd.asd','S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_bd_lieDownFloor_001_120.amc',[],0,1);
%[skel2,mot2]=readMocap('S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr.asf','S:\data_MoCap\MoCaDaDB\HDM\Training\lieDownFloor\HDM_tr_lieDownFloor_020_120.amc',[],0,1);

[skel1,mot1]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_01_120.amc',[],1,1);
[skel2,mot2]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_02_120.amc',[],1,1);

%close all;

downsampling_fac = 24;
rho = 0;

C = distMatrix_pointCloudDistance(mot1.jointTrajectories,mot2.jointTrajectories,downsampling_fac,rho,false);
figure;
imagesc(C);
axis xy; axis equal; set(gca,'xlim',[1 size(C,2)],'ylim',[1 size(C,1)]);
colormap hot; colorbar;

% CPC = distMatrix_pointCloudDistance(motPC.jointTrajectories,motPC.jointTrajectories,downsampling_fac,rho);
% figure;
% imagesc(CPC);
% axis xy; axis equal; set(gca,'xlim',[1 size(CPC,2)],'ylim',[1 size(CPC,1)]);
% colormap hot; colorbar;

% C = distMatrix_pointCloudDistance(mot.jointTrajectories,mot.jointTrajectories,downsampling_fac,rho);
% figure;
% imagesc(C);
% axis xy; axis equal; set(gca,'xlim',[1 size(C,2)],'ylim',[1 size(C,1)]);
% colormap hot; colorbar;