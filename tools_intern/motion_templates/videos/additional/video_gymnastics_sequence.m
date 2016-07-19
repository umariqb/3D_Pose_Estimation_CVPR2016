global VARS_GLOBAL

close all hidden;
 
%%%%%%%%%%%%%%%%% print skeleton trace poses
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end
VARS_GLOBAL_ANIM.ground_tile_size_factor = 1;
VARS_GLOBAL_ANIM.figure_color = [192 192 192]/255;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 20;
VARS_GLOBAL_ANIM.figure_position = [5 150 320 240];
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 24;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4.5;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
rehash path;

[info,OK] = filename2info('HDM\Uncut\mm\HDM_mm_3-5_c_120.amc');
[skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.asfname),fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.amcname));
VARS_GLOBAL_ANIM.figure_camera_file = 'cam_video_gymnastics_sequence';
figure; cameratoolbar('setmode','orbit'); cameratoolbar('show'); cameratoolbar('setcoordsys','y');
%animate(skel,mot);
animateVideo([skel],[mot],['render\video_gymnastics_sequence.avi'],1,1,4,{[]},[0],30);
