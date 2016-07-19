global VARS_GLOBAL

close all hidden;
 
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
files = [1 7 9 17];
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
VARS_GLOBAL_ANIM.figure_position = [5 150 320 240];
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 24;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4.5;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
%VARS_GLOBAL_ANIM.video_compression = 'MSUD';
rehash path;

ranges = {[50:340],[190:450],[135:400],[15:280]}; % file 16: [110 190 265]
%hold_frames = {[1 ones(1,73) 1],[4 ones(1,66) 5], [6 ones(1,63) 6], [5 ones(1,65) 5]};
%hold_frames_sequence = {[31 ones(1,73) 315],[134 ones(1,66) 219], [231 ones(1,63) 125], [323 ones(1,65) 31]};
hold_frames = videoRangesToHoldFrames(ranges,4);
hold_frames_sequence = videoRangesToHoldFramesSequence([ranges; {30 30 30 30}; {0 0 0 30}],4);
hold_frames_slomo4over3 = videoRangesToHoldFrames(ranges,3);
hold_frames_sequence_slomo4over3 = videoRangesToHoldFramesSequence([ranges; {30 30 30 30}; {0 0 0 30}],3);
hold_frames_slomo2 = videoRangesToHoldFrames(ranges,2);
hold_frames_sequence_slomo2 = videoRangesToHoldFramesSequence([ranges; {30 30 30 30}; {0 0 0 30}],2);

for i=1:4
    [info,OK] = filename2info(filenames{i});
    [skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.asfname),fullfile(VARS_GLOBAL.dir_root,info.amcpath,info.amcname));
    VARS_GLOBAL_ANIM.figure_camera_file = ['cam_video_4cartwheels_' num2str(i)];
    figure; cameratoolbar('setmode','orbit'); cameratoolbar('show'); cameratoolbar('setcoordsys','y');

  %  animate(skel,mot,1,0.3,ranges{i},0);
  
    animateVideo([skel],[mot],['render\video_4cartwheels_' num2str(i) '.avi'],1,1,4,{ranges{i}},[0],30,hold_frames{i});
    animateVideo([skel],[mot],['render\video_4cartwheels_sequence_' num2str(i) '.avi'],1,1,4,{ranges{i}},[0],30,hold_frames_sequence{i});

    animateVideo([skel],[mot],['render\video_4cartwheels_' num2str(i) '_slomo4over3.avi'],1,1,3,{ranges{i}},[0],30,hold_frames_slomo4over3{i});
    animateVideo([skel],[mot],['render\video_4cartwheels_sequence_' num2str(i) '_slomo4over3.avi'],1,1,3,{ranges{i}},[0],30,hold_frames_sequence_slomo4over3{i});

    animateVideo([skel],[mot],['render\video_4cartwheels_' num2str(i) '_slomo2.avi'],1,1,2,{ranges{i}},[0],30,hold_frames_slomo2{i});
    animateVideo([skel],[mot],['render\video_4cartwheels_sequence_' num2str(i) '_slomo2.avi'],1,1,2,{ranges{i}},[0],30,hold_frames_sequence_slomo2{i});
end

concatVideos_spatial({'render\video_4cartwheels_1.avi' 'render\video_4cartwheels_2.avi' },'render\video_4cartwheels_12.avi','h');
concatVideos_spatial({'render\video_4cartwheels_3.avi' 'render\video_4cartwheels_4.avi' },'render\video_4cartwheels_34.avi','h');
concatVideos_spatial({'render\video_4cartwheels_34.avi' 'render\video_4cartwheels_12.avi'},'render\video_4cartwheels.avi','v');
concatVideos_spatial({'render\video_4cartwheels_sequence_1.avi' 'render\video_4cartwheels_sequence_2.avi' },'render\video_4cartwheels_sequence_12.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_3.avi' 'render\video_4cartwheels_sequence_4.avi' },'render\video_4cartwheels_sequence_34.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_34.avi' 'render\video_4cartwheels_sequence_12.avi' },'render\video_4cartwheels_sequence.avi','v');

concatVideos_spatial({'render\video_4cartwheels_1_slomo4over3.avi' 'render\video_4cartwheels_2_slomo4over3.avi' },'render\video_4cartwheels_12_slomo4over3.avi','h');
concatVideos_spatial({'render\video_4cartwheels_3_slomo4over3.avi' 'render\video_4cartwheels_4_slomo4over3.avi' },'render\video_4cartwheels_34_slomo4over3.avi','h');
concatVideos_spatial({'render\video_4cartwheels_34_slomo4over3.avi' 'render\video_4cartwheels_12_slomo4over3.avi'},'render\video_4cartwheels_slomo4over3.avi','v');
concatVideos_spatial({'render\video_4cartwheels_sequence_1_slomo4over3.avi' 'render\video_4cartwheels_sequence_2_slomo4over3.avi' },'render\video_4cartwheels_sequence_12_slomo4over3.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_3_slomo4over3.avi' 'render\video_4cartwheels_sequence_4_slomo4over3.avi' },'render\video_4cartwheels_sequence_34_slomo4over3.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_34_slomo4over3.avi' 'render\video_4cartwheels_sequence_12_slomo4over3.avi' },'render\video_4cartwheels_sequence_slomo4over3.avi','v');

concatVideos_spatial({'render\video_4cartwheels_1_slomo2.avi' 'render\video_4cartwheels_2_slomo2.avi' },'render\video_4cartwheels_12_slomo2.avi','h');
concatVideos_spatial({'render\video_4cartwheels_3_slomo2.avi' 'render\video_4cartwheels_4_slomo2.avi' },'render\video_4cartwheels_34_slomo2.avi','h');
concatVideos_spatial({'render\video_4cartwheels_34_slomo2.avi' 'render\video_4cartwheels_12_slomo2.avi'},'render\video_4cartwheels_slomo2.avi','v');
concatVideos_spatial({'render\video_4cartwheels_sequence_1_slomo2.avi' 'render\video_4cartwheels_sequence_2_slomo2.avi' },'render\video_4cartwheels_sequence_12_slomo2.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_3_slomo2.avi' 'render\video_4cartwheels_sequence_4_slomo2.avi' },'render\video_4cartwheels_sequence_34_slomo2.avi','h');
concatVideos_spatial({'render\video_4cartwheels_sequence_34_slomo2.avi' 'render\video_4cartwheels_sequence_12_slomo2.avi' },'render\video_4cartwheels_sequence_slomo2.avi','v');
