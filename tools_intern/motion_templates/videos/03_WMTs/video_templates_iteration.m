global VARS_GLOBAL
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end
VARS_GLOBAL_ANIM.video_compression = 'PNG1';
VARS_GLOBAL_ANIM.figure_position = [5 100 640 480];


close all hidden;
 
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
%files = [17 1 6 9];
%ranges = {[1:285],[1:370],[10:390],[1:390]}; % file 16: [110 190 265]
files = [9 1 6 17];
ranges = {[1:390],[1:370],[10:390],[1:285]}; % file 16: [110 190 265]

category = 'cartwheelLHandStart1Reps';
basedir = fullfile('HDM', 'Training','');
settings = ['1_40_' sampling_rate_string];
feature_set_array = {'AK_upper','AK_lower','AK_mix'};
features_select = [3 4 5 6 15 16 29 30 33 34];
%template_frames_select = [20:90]

[U,filenames,feature_set_ranges] = func_fig_features_decode_category(basedir,category,feature_set_array,{files},downsampling_fac);

for k=1:length(U)
    U{k} = U{k}(:,ceil(ranges{k}(1)/downsampling_fac):floor(ranges{k}(end)/downsampling_fac));
end

myfig = figure;
set(gcf,'pos',[5 100 640 480]);
set(gcf,'color',[192 192 192]/255);
left = [0.01 0.505 0.01 0.505];
bottom = [0.545 0.545 0.05 0.05];
width = 0.475;
height = 0.375;

num_iter = 4;
render_video = ones(1,num_iter);
%render_video = zeros(1,num_iter);
times = 2*ones(1,num_iter);

for j=2:num_iter
% Generate Templates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    parameter.visCost            = 0;
    parameter.visWarp            = 0;
    parameter.visTemplate        = 0;
    parameter.visIterations      = 0;
    parameter.visLastIteration   = 0;
    parameter.visVrepW           = 0;
    parameter.visTemplateFinal   = 0;
    parameter.visStatistics = 0;
    parameter.downsampling_fac   = downsampling_fac;
    parameter.VrepWoverlapFactor = 0.0; % parameter.VrepWoverlapFactor = 0 yields same behavior as "classical" connected components approach
    parameter.templateComputationStrategy = 5;
    parameter.basedir = basedir; % fullfile('HDM', 'Training',category,'')
    parameter.category = category;
    parameter.files = files;
    parameter.feature_set = feature_set_array;
    parameter.iter_max           = j;
    parameter.iter_thresh        = 0.0005;
%     parameter.iter_max           = 200;
%     parameter.iter_thresh        = eps;
    parameter.conjoin = 0;
   
    [mtr,mtw,mtk,stats,U_out,Uweights] = func_fig_motionTemplateGenerateDTWIterative(parameter,U);

    max_x = 0;
    for k=1:length(U_out)
        max_x = max(max_x,size(U_out{k},2));
    end
    for k=1:length(U_out)
        if (j>2)
            delete(axes_U(k));
            delete(axes_Uweights(k));
        end
        axes_U(k) = axes('position',[left(k) bottom(k) width*size(U_out{k},2)/max_x height]);
        imagesc(U_out{k}(features_select,:),[0 1]); colormap hot;
        set(gca,'fontsize',8);
        UCbar(k) = colorbar; set(UCbar(k),'ytick',[0 0.5 1],'position',get(UCbar(k),'position')-[0.01 0 0 0]);
        set(UCbar(k),'fontsize',8);
        set(gca,'ytick',[]);
        set(gca,'xtick',[10 20 30 40 50 60 70 80]);
        axes_Uweights(k) = axes('Position',[left(k) bottom(k)+height+0.01 width*size(U_out{k},2)/max_x 0.05]);
        imagesc(Uweights{k},[0 2]);
        set(gca,'ytick',[])
        set(gca,'xtick',[])
        set(gca,'fontsize',8);
        weightsCbar(k) = colorbar;    
        set(weightsCbar(k),'ytick',[ 1 2],'position',get(weightsCbar(k),'position')-[0.01 0 0 0]);
        set(weightsCbar(k),'fontsize',8);
    end
    drawnow;
    if (render_video(j))
        if (j==2)
            open_avi = true;
            close_avi = false;
        elseif (j<num_iter)
            open_avi = false;
        else
            close_avi = true;
        end
            
        grabVideoFrames(myfig,times(j)*30,['render/video_templates_iterations.avi'],open_avi,close_avi);
    end
    
end
    

%     
%     param.thresh_lo = 0.1;
%     param.thresh_hi = 0.9;
%     param.visBool = 0;
%     param.visReal = 0;
%     param.visBoolRanges = 0;
%     param.visRealRanges = 0;
%     param.feature_set_ranges = {[1:8]};
%     param.feature_set = feature_set_array;
%     param.flag = 2;
%     [motionTemplateBoolean,weightsBoolean] = func_fig_motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);
