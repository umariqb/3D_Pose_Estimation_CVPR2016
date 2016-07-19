close all;

[skel1,mot1]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_01_120.amc',[100 120],1,1);
[skel2,mot2]=readMocap('S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd.asf','S:\data_MoCap\HDM\HDM_clean\bd\asf_amc\HDM_bd_04-01_02_120.amc',[500 520],1,1);

rho = 3;

Ptraj = mot1.jointTrajectories;
Qtraj = mot2.jointTrajectories;
njoints = mot1.njoints;

theta = 0:0.01:2*pi;

for k = 1:length(theta)
    d(k) = pointCloudDistance(Ptraj,Qtraj,10,10,rho,theta(k));
end

figure;
plot3(cos(theta),sin(theta),d);

figure;
plot(theta/(2*pi),d);