global VARS_GLOBAL

close all hidden;
 
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
files = [11 7 10 21];
category = 'cartwheelLHandStart1Reps';
basedir_features = fullfile('HDM', 'Training','_features','');
settings = ['1_40_' sampling_rate_string];
feature_set_array = {'AK_lower'};

[U,filenames,feature_set_ranges] = features_decode_category(basedir_features,category,feature_set_array{1},{files},downsampling_fac);

%%%%%%%%%%%%%%%%% print skeleton trace poses
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end
VARS_GLOBAL_ANIM.ground_tile_size_factor = 1;
VARS_GLOBAL_ANIM.figure_color = [192 192 192]/255;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 20;
VARS_GLOBAL_ANIM.figure_position = [5 150 640 240];
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 24;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4.5;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
%VARS_GLOBAL_ANIM.video_compression = 'MSUD';
rehash path;

ranges = {[30:340],[190:450],[145:440],[1:280]}; % file 16: [110 190 265]
hold_frames = [5 ones(1,56) 100 ones(1,26) 100 ones(1,94) 100 ones(1,130)  79  ];


f=1;

[info,OK] = filename2info(filenames{f});
[skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.asfname),fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.amcname));
VARS_GLOBAL_ANIM.figure_camera_file = ['cam_video_cartwheel_stopmotion'];
figure; cameratoolbar('setmode','orbit'); cameratoolbar('show'); cameratoolbar('setcoordsys','y');

%animate(skel,mot,1,1,ranges{f},1);
% animate(skel,mot,1,0.25,[160],1);

animateVideo([skel],[mot],['render\video_cartwheel_stopmotion.avi'],1,1,1,{ranges{f}},[0],30,hold_frames);

concatVideos_spatial({'render\video_cartwheel_stopmotion.avi' 'render/video_class_template_cartwheel_discussion.avi' },'render/video_class_template_cartwheel_discussion_concat.avi','v');
