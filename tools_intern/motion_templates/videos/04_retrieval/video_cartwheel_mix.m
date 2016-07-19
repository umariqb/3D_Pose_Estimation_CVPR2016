close all;

global VARS_GLOBAL
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
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 20;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
rehash path;

%range = [2100:3720];
range = [1700:3500];

[info,OK] = filename2info('HDM\Uncut\tr\HDM_tr_5-3_d_120.amc');
[skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.asfname),fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.amcname));
VARS_GLOBAL_ANIM.figure_camera_file = ['cam_video_cartwheel_mix'];
figure; cameratoolbar('setmode','orbit'); cameratoolbar('show'); cameratoolbar('setcoordsys','y');

%animate(skel,mot,1,4,range,1);
% animate(skel,mot,1,0.25,[160],1);

%animateVideo([skel],[mot],['render\video_cartwheel_mix.avi'],1,1,4,{range},[0],30);

% concatVideos_spatial({'render\video_cartwheel_mix.avi' 'render\video_delta_cartwheel_mix.avi' },'render/video_cartwheel_mix_concat.avi','v');
concatVideos_spatial({'render\video_template_cartwheel_allfeatures_bool_padding.avi' 'render\video_cartwheel_mix_concat.avi' },'render/video_cartwheel_mix_final.avi','h');