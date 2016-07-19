close all;

global VARS_GLOBAL
%%%%%%%%%%%%%%%%% print skeleton trace poses
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end
VARS_GLOBAL_ANIM.ground_tile_size_factor = 1;
VARS_GLOBAL_ANIM.figure_color = [192 192 192]/255;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 100;
VARS_GLOBAL_ANIM.figure_position = [5 150 640 480];
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 11;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 3;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
rehash path;

downsampling_fac = 4;

VARS_GLOBAL_ANIM.figure_camera_file = ['cam_video_hits_throwR'];

%load hits_throwR_004
load hits_throwR_002

for k=1:length(hits)
    hits(k).frame_first_matched = hits(k).frame_first_matched*downsampling_fac-(downsampling_fac-1);
    hits(k).frame_last_matched = hits(k).frame_last_matched*downsampling_fac-(downsampling_fac-1);
end

%[cs,cm] = animateSimultaneous(hits,1,1,[],5,[8 7],'',4,30,pi/2);
%animate(cs,cm,1,1,cell(1,length(cm)),zeros(length(cm)));
%animateVideo(cs,cm,'render/video_hits_throwR_004.avi',1,1,4,cell(1,length(cm)),zeros(length(cm)),30);
% animateVideo(cs,cm,'render/video_hits_throwR_002.avi',1,1,4,cell(1,length(cm)),zeros(length(cm)),30);
%animateSimultaneous(hits,1,1,[],4,[6 6],'render/video_hits_throwR_002.avi',4,30,-3*pi/4);
%animateSimultaneous(hits,1,1,[],4,[6 6],'render/video_hits_throwR_002.avi',4,30,-3*pi/4);

% animatedTransparencyOverlay('render/video_hits_throwR_002.avi', 'render/overlay_tau_002_right.tif', 'render/video_hits_throwR_002_overlay.avi', [192 192 192],[],[],0);
animatedTransparencyOverlay('render/video_hits_throwR_004.avi', 'render/overlay_tau_004_right.tif', 'render/video_hits_throwR_004_overlay.avi', [192 192 192],[],[],0);

