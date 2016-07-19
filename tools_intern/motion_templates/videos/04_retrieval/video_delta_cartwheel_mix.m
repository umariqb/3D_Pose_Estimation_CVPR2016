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
category = 'cartwheelLHandStart1Reps';
sampling_rate_string = num2str(120/downsampling_fac);
basedir = fullfile('HDM', 'Training','');
basedir_features = fullfile('HDM', 'Uncut','_features','');
basedir_templates = fullfile('HDM', 'Training','_templates','');
settings = ['5_0_' sampling_rate_string];
feature_set_ranges = {1:14,15:26,27:39};
feature_set = {'AK_upper','AK_lower','AK_mix'};
[DB,filenames] = features_decode_category(basedir_features,{'HDM_uncut'},feature_set,{322},downsampling_fac);
DB_concat = features_concatenate(DB,filenames,false);

%range = [2100:3720];
range = [1700:downsampling_fac:3500];
range = ceil(1700/downsampling_fac)+[0:length(range)-2];


[motionTemplate,motionTemplateWeights,motionTemplateKeyframes,parameter] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
motionTemplateReal = motionTemplate;
motionTemplateWeights = motionTemplateWeights;
param.thresh_lo = 0.1;
param.thresh_hi = 1-param.thresh_lo;
param.visBool = 0;
param.visReal = 0;
param.visBoolRanges = 0;
param.visRealRanges = 0;
param.feature_set_ranges = feature_set_ranges;
param.feature_set = feature_set;
param.flag = 0;
[motionTemplateBool,motionTemplateBoolWeights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);

parameter.visCost      = 9;
parameter.match_numMax = 100;
parameter.match_thresh = 0.06;
parameter.match_endExclusionForward = 0.1;
parameter.match_endExclusionBackward = 0.5;
parameter.match_startExclusionForward = 0.5;
parameter.match_startExclusionBackward = 0.1;
parameter.expandV = 1;
[hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(motionTemplateBool,motionTemplateBoolWeights,DB_concat.features,ones(1,size(DB_concat.features,2)),parameter,...
    [1 1 2],[1 2 1],[1 1 2]);

figure('position',[5 100 320 240],'renderer','opengl','color',[192 192 192]/255);
h = axes('position',[0.1 0.1 0.88 0.84]);
plot(delta(range),'r','linewidth',1.5); hold on;
set(h,'xlim',[1 length(range)+1],'ylim',[0 0.28]);
h = plot([1 1],[0 0.28],'b');

render_video = 1;
num_frames = length(range);
for k=1:num_frames
    set(h,'xdata',[k k]);
    drawnow;
    
    if (render_video)
        if (k==1)
            open_avi = true;
            close_avi = false;
        elseif (k<num_frames)
            open_avi = false;
        else
            close_avi = true;
        end
        grabVideoFrames(myfig,1,['render/video_delta_cartwheel_mix.avi'],open_avi,close_avi);
    end
end

