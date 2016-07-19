%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matching motions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all hidden;



clear all;
currentDir = pwd;
cd('S:\roedert\matlab\mocap_new');
meinard;
cd(currentDir);

%animated(1,5,0.25); %id,rep,speed

parameter.figure_position = [360   514   560   420];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: jumps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id = 13;           %stand 4 jumps turn 4 jumps turn 3 jumps
% range1=[100:400];  %first 2 jumps
% range2=[100:900];  %first 4 jumps
% [skel,mot]=readMocapD(id); %animate(skel,mot);
% mot1 = cropMot(mot,range2);
% mot2 = cropMot(mot,range2);
% parameter.joints          = [  2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23];
% %parameter.figure_position = [360   469   560   465];
% parameter.printName = 'fig_selfsim_jumps.eps';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: HDM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  [skel,mot]=readMocap('S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\bastian\bastian.asf','S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\bastian\Bastian.3_4bBD.AMC')
%  range1=[2190:3310];  
% %[skel,mot]=readMocap('S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\meinard\meinard.asf','S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\meinard\Meinard.3_4bMM.AMC')
% %range1=[4600:6500];  
% %[skel,mot]=readMocap('S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\tido\tido.asf','S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\tido\Tido.3_4aTR.AMC')
% %range1=[4600:5800];  
% mot1 = cropMot(mot,range1);
% mot2 = mot1;
% %parameter.joints = [2 3 4 6 7 8];  % lower
% %parameter.joints = [10 11 12 13 16 17 18 21 22 23];  % upper
% parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23]; % all
% parameter.printName = 'fig_selfsim_armrotate.eps';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example: gymnastics
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id = 146; 
% [skel,mot]=readMocapD(id); %animate(skel,mot);
% range1=[1:2160]; %three jumping jacks, running, two squatting, ...
% mot1 = cropMot(mot,range1);
% mot2 = cropMot(mot,range1);
% % parameter.joints = [2 3 4 6 7 8];  %two cartwheels are identified as similar by C
% parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23]; %no similarity between cartwheels
% parameter.printName = 'fig_selfsim_gymnastics.eps';

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Example: cartwheels
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id = 89;    %two cartweels
% [skel,mot]=readMocapD(id); %animate(skel,mot);
% mot1 = mot;
% mot2 = mot;
% parameter.joints = [2 3 4 6 7 8];  % lower
% %parameter.joints = [10 11 12 13 16 17 18 21 22 23];  % upper
% %parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23]; % all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: cartwheels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[skel,mot]=readMocap('..\..\parser\testdata\HDM_tr.asf','..\..\parser\testdata\HDM_5_3aTR.amc');
mot1 = mot;
mot2 = mot;
%parameter.joints = [2 3 4 6 7 8];  % lower
%parameter.joints = [10 11 12 13 16 17 18 21 22 23];  % upper
parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23]; % all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: two walking motions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id = 41;    %walking 5 steps beginning with left foot, brisk
% [skel1,mot1]=readMocapD(id); %animate(skel,mot);
% range = [2:263];
% mot1 = cropMot(mot1,range);
% id = 40;    %walking 5 steps beginning with left foot, slow
% [skel2,mot2]=readMocapD(id); %animate(skel,mot);
% parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23];
% parameter.figure_position = [360   514   858   420];
% parameter.printName = 'fig_sim_walkslow_walkfast.eps';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: two kicking motions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% id = 157;    %2 kicking motions
% [skel1,mot1]=readMocapD(id); %animate(skel,mot);
% range1 = [2000:2450];
% mot1 = cropMot(mot1,range1);
% id = 160;    %2 kicking motions
% [skel2,mot2]=readMocapD(id); %animate(skel,mot);
% range2 = [2590:3110];
% mot2 = cropMot(mot2,range2);
% parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23];
% %parameter.figure_position = [360   514   858   420];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: two walking motions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [skel1,mot1]=readMocap('S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\bastian\bastian.asf','S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\bastian\Bastian.3_4bBD.AMC')
% range1=[100:4000];  
% mot1 = cropMot(mot1,range1);
% [skel2,mot2]=readMocap('S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\meinard\meinard.asf','S:\data_MoCap\HDM\Bonn_ASF_AMC_Use IK_on\meinard\Meinard.3_4bMM.AMC')
% range2=[100:2000];  
% mot2 = cropMot(mot2,range2);
% parameter.joints = [2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23];
% % %parameter.figure_position = [360   514   858   420];


%parameter.filter_len     = 21;
parameter.downsample     = 1;
parameter.filter_len     = 1;
%parameter.downsample     = 10;
%parameter.joints         = [2 3 6 7];
%parameter.joints          = [  2 3 4  6 7 8 10 11 12 13 16 17 18 21 22 23];
%parameter.jointsWeight    = [ .5 1 1 .5 1 1 .2 .2 .2 .1 .5  1  1 .5  1  1]; 
parameter.jointsWeight    = ones(1,length(parameter.joints))/length(parameter.joints); 
parameter.visualize      = [1 1 1];

[C,q1,q2] = costMatrixQuat(mot1,mot2,parameter);
set(gcf,'color','w');


colormap(hot);  colorbar;

set(gcf,'PaperPosition',[1   10   10  5]); %[left, bottom, width, height]
print('-depsc2',parameter.printName);
