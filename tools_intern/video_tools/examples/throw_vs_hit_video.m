close all

[skel,mot]=readMocap('M:\data_MoCap\bvh\redeye\make-snowball_5.bvh');

figure;
global VARS_GLOBAL_ANIM
VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
VARS_GLOBAL_ANIM.animated_skeleton_Color = [0 0 0]/255;
VARS_GLOBAL_ANIM.animated_skeleton_Marker = '.';
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 14;
VARS_GLOBAL_ANIM.animated_point_MarkerSize = 12;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4;
VARS_GLOBAL_ANIM.ground_tile_size_factor = 2;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 18;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = [255 00 00]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = [255 00 00]/255;
VARS_GLOBAL_ANIM.figure_position = [5 5 512 384];
%VARS_GLOBAL_ANIM.figure_position = [5 5 254 384];
rehash path;
VARS_GLOBAL_ANIM.figure_camera_file = 'throw_vs_hit_3_camera';
mot.rootTranslation(2,:) = mot.rootTranslation(2,:)-50;
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
mot = moveMotToXZ(mot,[80;-175]); 

[skel2,mot2]=readmocapd(162);
mot3 = moveMotToXZ(mot2,[0;0]); 
skel3 = skel2;
fac = 14;
for k=1:length(skel3.nodes)
    skel3.nodes(k).length = skel3.nodes(k).length*fac;
    skel3.nodes(k).offset = skel3.nodes(k).offset*fac;
end
mot3.rootTranslation = mot3.rootTranslation*fac-10;
mot3.jointTrajectories = forwardKinematicsQuat(skel3,mot3);
alpha = pi/2;
mot3 = rotateMotY(skel3,mot3,[cos(alpha);sin(alpha)],'lshoulder','rshoulder'); % orientate front vector


animate([skel skel3],[mot mot3],1,1,{[155:190] [4817:4:4960]});

%animate(skel,mot,1,1,[155:190]);
% animateVideo(skel,mot,'throw_vs_hit_video1.avi',1,1,1,[155:190],[]);
% 
% figure;
% VARS_GLOBAL_ANIM.figure_position = [260 5 254 384];
% VARS_GLOBAL_ANIM.figure_camera_file = 'throw_vs_hit_2_camera';
% [skel,mot]=readmocapd(162);
% 
% animateVideo(skel,mot,'throw_vs_hit_video2.avi',1,1,4,[4817:4960],[]);
% 
% padVideo('throw_vs_hit_video1.avi','throw_vs_hit_video1_padded.avi',[192 192 192],4,'r');
% concatVideos_spatial({'throw_vs_hit_video1_padded.avi','throw_vs_hit_video2.avi'},'throw_vs_hit_video.avi','h');
