global VARS_GLOBAL_ANIM

close all

upsampling_fac = 2.5;

[skel,mot] = readMocap(fullfile(VARS_GLOBAL.dir_root,'HDM\Uncut\tr','HDM_tr.asf'),fullfile(VARS_GLOBAL.dir_root,'HDM\Uncut\tr','HDM_tr_5-3_d_120.amc'));

%mot.rootTranslation = mot.rootTranslation + repmat([45; 0; 45],1,mot.nframes);
mot = resampleMot(mot,mot.samplingRate*upsampling_fac);
mot.samplingRate = mot.samplingRate/upsampling_fac;
mot.frameTime = mot.frameTime*upsampling_fac;

range = [5780:6100];
range1 = [ceil(upsampling_fac*range(1)):ceil(upsampling_fac*range(end))];
%range1 = [51:141];

lindgruen = [0.75 1 0.75];
cyan = [0 1 1];
mot1 = cropMot(mot,range1);

fr1 = feature_AK_bool_handRightRaisedRelSpine(mot1);
point_color_r1 = repmat(fr1',1,3).*repmat(lindgruen,mot1.nframes,1)+repmat((1-fr1)',1,3).*repmat([0 0 0],mot1.nframes,1);
mot1 = addAnimatedPatches(mot1,...
                        {'params_planePointNormal','params_point','params_point','params_point'},...
                        {{'chest','neck','neck','rwrist',0},{'chest'},{'neck'},{'rwrist'}},...
                        {'disc','point','point','point'},...
                        {[0 1 0],[1 0 0],[1 0 0],point_color_r1},...
                        [0.7 1 1 1],...
                        true);
%%
VARS_GLOBAL_ANIM.animated_skeleton_Color = [0 0 0]/255;
VARS_GLOBAL_ANIM.animated_skeleton_Marker = '.';
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 18;
VARS_GLOBAL_ANIM.animated_point_MarkerSize = 16;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 5;
VARS_GLOBAL_ANIM.ground_tile_size_factor = 2;
VARS_GLOBAL_ANIM.bounding_box_border_extension = 8;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = [100 100 100]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = [100 100 100]/255;
VARS_GLOBAL_ANIM.figure_position = [5 100 640 380];
VARS_GLOBAL_ANIM.figure_camera_file = 'cam_video_feature_rhand_raised';
VARS_GLOBAL_ANIM.video_compression = 'PNG1';

rehash path;

figure;
%animate([skel],[mot1],1,1,{[]},[0]);
%animateVideo([skel],[mot1],'render/video_feature_rhand_raised.avi',1,1,1,{[]},[0],30);


% concatVideos_spatial({'render/video_feature_rhand_raised.avi','render/video_feature_rhand_raised_boolean.avi'},'render/video_feature_rhand_raised_combined.avi','v')
%sustainVideoFrames('feature_boxing_video_final.avi','feature_boxing_video_final2.avi',[mot1.nframes],[60])

% padVideo('walk_video.avi','walk_video_padded.avi',[192 192 192],100,'b');
% concatVideosSmooth_temporal({'title_geometric_features.avi','walk_video_padded.avi'},'walk_video_final.avi',{'emptyGray512x384.tif'},0.25);