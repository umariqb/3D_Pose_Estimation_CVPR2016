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
feature_set_ranges = {1:14,15:26,27:39};
feature_set = {'AK_upper','AK_lower','AK_mix'};

load motionTemplates_4cartwheels_iteration32_b

motionTemplateReal = U_out{1};
motionTemplateWeights = Uweights{1};
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

figure('position',[5 100 640 480],'color',[192 192 192]/255);
h = axes('units','pixels','position',[5 20 310 455]);
imagesc(motionTemplateReal,[0 1]); colormap hot;
set(gca,'ytick',[]);

render_video = [1 0 0];
num_frames = [7 3.5]*30;
if (render_video(1))
    for k=1:num_frames(1)
        if (k==1)
            open_avi = true;
            close_avi = false;
        elseif (k<num_frames(1))
            open_avi = false;
        else
            close_avi = true;
        end
        grabVideoFrames(myfig,1,['render/video_template_cartwheel_allfeatures_real.avi'],open_avi,close_avi);
    end
end

delete(h);
h = axes('units','pixels','position',[5 20 310 455]);
imagesc(motionTemplateBool,[0 1]); colormap gray;
set(gca,'ytick',[]);

if (render_video(2))
    for k=1:num_frames(2)
        if (k==1)
            open_avi = true;
            close_avi = false;
        elseif (k<num_frames(2))
            open_avi = false;
        else
            close_avi = true;
        end
        grabVideoFrames(myfig,1,['render/video_template_cartwheel_allfeatures_bool.avi'],open_avi,close_avi);
    end
end

set(gcf,'position',[5 100 320 480]);
range = [1700:downsampling_fac:3500];
range = ceil(1700/downsampling_fac)+[0:length(range)-2];
num_frames(3) = length(range);
if (render_video(3))
    for k=1:num_frames(3)
        if (k==1)
            open_avi = true;
            close_avi = false;
        elseif (k<num_frames(3))
            open_avi = false;
        else
            close_avi = true;
        end
        grabVideoFrames(myfig,1,['render/video_template_cartwheel_allfeatures_bool_padding.avi'],open_avi,close_avi);
    end
end
