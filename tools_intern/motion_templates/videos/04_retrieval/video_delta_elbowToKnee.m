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
VARS_GLOBAL_ANIM.figure_position = [5 150 640 240];
VARS_GLOBAL_ANIM.animated_skeleton_MarkerEdgeColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerFaceColor = 'red';%[200 200 200]/255;
VARS_GLOBAL_ANIM.animated_skeleton_MarkerSize = 24;
VARS_GLOBAL_ANIM.animated_skeleton_LineWidth = 4.5;
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
rehash path;

downsampling_fac = 4;
category = 'elbowToKnee1RepsRelbowStart';
sampling_rate_string = num2str(120/downsampling_fac);
basedir = fullfile('HDM', 'Training','');
basedir_features = fullfile('HDM', 'Uncut','_features','');
basedir_templates = fullfile('HDM', 'Training','_templates','');
settings = ['5_0_' sampling_rate_string];
feature_set_ranges = {1:14,15:26,27:39};
feature_set = {'AK_upper','AK_lower','AK_mix'};
[DB,filenames] = features_decode_category(basedir_features,{'HDM_uncut'},feature_set,{248},downsampling_fac);
DB_concat = features_concatenate(DB,filenames,false);

range = [18:1073];

[motionTemplate,motionTemplateWeights,motionTemplateKeyframes,parameter] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
motionTemplateReal = motionTemplate;

param.thresh_lo = 0.1;
param.thresh_hi = 1-param.thresh_lo;
param.visBool = 0;
param.visReal = 0;
param.visBoolRanges = 0;
param.visRealRanges = 0;
param.feature_set_ranges = feature_set_ranges;
param.feature_set = feature_set;
param.flag = 0;
[motionTemplateBoolean,motionTemplateBoolWeights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);

parameter.visCost      = 9;
parameter.match_numMax = 100;
parameter.match_thresh = 0.06;
parameter.match_endExclusionForward = 0.1;
parameter.match_endExclusionBackward = 0.5;
parameter.match_startExclusionForward = 0.5;
parameter.match_startExclusionBackward = 0.1;
parameter.expandV = 1;
[hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(motionTemplateBoolean,motionTemplateBoolWeights,DB_concat.features,ones(1,size(DB_concat.features,2)),parameter,...
    [1 1 2],[1 2 1],[1 1 2]);

myfig=figure('position',[5 100 320 240],'renderer','opengl','color',[192 192 192]/255);
h = axes('position',[0.1 0.1 0.88 0.84]);
plot(delta(range),'r','linewidth',1.5); hold on;
plot([1 length(range)],[0.06 0.06],'b');
set(h,'xlim',[1 length(range)],'ylim',[0 0.35]);
text(10,0.03,'Threshold \tau = 0.06','fontsize',12,'fontweight','bold','color','b');

render_video = 1;
num_frames = 450;
for k=1:num_frames
    if (render_video)
        if (k==1)
            open_avi = true;
            close_avi = false;
        elseif (k<num_frames)
            open_avi = false;
        else
            close_avi = true;
        end
        grabVideoFrames(myfig,1,['render/video_delta_elbowToKnee.avi'],open_avi,close_avi);
    end
end

concatVideos_spatial({'render/video_hits_elbowToKnee_concat.avi','render/video_delta_elbowToKnee.avi'},'render/video_delta_hits_elbowToKnee.avi','v')
concatVideos_spatial({'render/video_template_elbowToKnee_allfeatures_bool_padding.avi','render/video_delta_hits_elbowToKnee.avi'},'render/video_elbowToKnee_combined.avi','h')