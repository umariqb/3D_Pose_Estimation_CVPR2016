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
files = [9 1 6 17];
%ranges = {[50:360],[190:495],[135:440],[15:285]}; % file 16: [110 190 265]
%ranges = {[1:285],[1:370],[10:390],[1:390]}; 
ranges = {[1:390],[1:370],[10:390],[1:285]}; % file 16: [110 190 265]

category = 'cartwheelLHandStart1Reps';
basedir = fullfile('HDM', 'Training','');
settings = ['1_40_' sampling_rate_string];
feature_set_array = {'AK_upper','AK_lower','AK_mix'};
features_select = [3 4 5 6 15 16 29 30 33 34];

[U,filenames,feature_set_ranges] = func_fig_features_decode_category(basedir,category,feature_set_array,{files},downsampling_fac);
for k=1:length(U)
    U{k} = U{k}(:,ceil(ranges{k}(1)/downsampling_fac):floor(ranges{k}(end)/downsampling_fac));
end

max_x = 0;
for k=1:length(U)
    max_x = max(max_x,size(U{k},2));
end

render_video = [1 1 1 1 1 1 1 1 1 1 1];
%render_video = [0 0 0 0 0 0 0 0 0 0 0];
times = [18 5 5 3.5 1.5 1.5 1.5 4.5 1 1 3];
%%%%%%%%%%%%%%%%% print feature matrices
myfig = figure;
set(gcf,'pos',[5 100 640 480]);
set(gcf,'color',[192 192 192]/255);

left = [0.01 0.505 0.01 0.505];
bottom = [0.545 0.545 0.05 0.05];
width = 0.475;
height = 0.375;
for k=1:length(U)
    axes_U(k) = axes('position',[left(k) bottom(k) width*size(U{k},2)/max_x height]);
    imagesc(U{k}(features_select,:),[0 1]); colormap hot;
    UCbar(k) = colorbar; set(UCbar(k),'visible','off'); set(UCbar(k),'position',get(UCbar(k),'position')-[0.01 0 0 0]); 
    set(UCbar(k),'fontsize',8);
    set(gca,'ytick',[]);
    set(gca,'fontsize',8);
end
if (render_video(1))
    grabVideoFrames(myfig,times(1)*30,'render/video_feature_matrices_noweights.avi');
end

for k=1:length(U)
    Uweights = ones(1,size(U{k},2));
    axes_Uweights(k) = axes('Position',[left(k) bottom(k)+height+0.01 width*size(U{k},2)/max_x 0.05]);
    imagesc(Uweights,[0 2]);
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    set(gca,'fontsize',8);
    weightsCbar = colorbar;    
    set(weightsCbar,'ytick',[ 1 2],'position',get(weightsCbar,'position')-[0.01 0 0 0]);
    set(weightsCbar,'fontsize',8);
end
if (render_video(2))
    grabVideoFrames(myfig,times(2)*30,'render/video_feature_matrices_weights.avi');
end

axes('Position',[0.0 0.5 0.4265 0.4975],'color','none','visible','off');
h_line=line([0 1 1 0 0],[1 1 0 0 1],'color',[0 150 255]/255,'linewidth',7);
if (render_video(3))
    grabVideoFrames(myfig,times(3)*30,'render/video_feature_matrices_reference_highlighted.avi');
end

load featureMatricesWarped_4cartwheels_iteration1_b
max_x = 0;
for k=1:length(U)
    max_x = max(max_x,size(Uwarp{k},2));
end
set(UCbar(1),'visible','on');
for k=2:length(U)
    delete(axes_U(k))
    axes_U(k) = axes('position',[left(k) bottom(k) width*size(Uwarp{k},2)/max_x height]);
    imagesc(Uwarp{k}(features_select,:),[0 1]); colormap hot;
    UCbar(k) = colorbar; set(UCbar(k),'ytick',[0 0.5 1],'position',get(UCbar(k),'position')-[0.01 0 0 0]);
    set(UCbar(k),'fontsize',8);
    set(gca,'ytick',[]);
    set(gca,'fontsize',8);
    delete(axes_Uweights(k));
    axes_Uweights(k) = axes('Position',[left(k) bottom(k)+height+0.01 width*size(Uwarp{k},2)/max_x 0.05]);
    imagesc(UwarpWeights(k,:),[0 2]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'fontsize',8);
    weightsCbar(k) = colorbar;    
    set(weightsCbar(k),'ytick',[ 1 2],'position',get(weightsCbar(k),'position')-[0.01 0 0 0]);
    set(weightsCbar(k),'fontsize',8);
end
if (render_video(4))
    grabVideoFrames(myfig,times(4)*30,'render/video_feature_matrices_warped.avi');
end

num_U = length(U);
UtemplateHelp = Uwarp{1};
UtemplateHelpWeights = UwarpWeights(1,:);
X = repmat(UwarpWeights(1,:),size(UtemplateHelp,1),1);    
for k=2:num_U
    alpha = repmat(UwarpWeights(k,:),size(UtemplateHelp,1),1);    
    UtemplateHelp = X.*UtemplateHelp + alpha.*Uwarp{k};
    X = X+alpha;    
    UtemplateHelp = UtemplateHelp./X;
    
    UtemplateHelpWeights = (((k-1)/num_U)*UtemplateHelpWeights + (1/num_U)*UwarpWeights(k,:))/(k/num_U);
    
    delete(axes_U(k));
    delete(axes_U(1));
    axes_U(1) = axes('position',[left(1) bottom(1) width*size(Uwarp{k},2)/max_x height]);
    imagesc(UtemplateHelp(features_select,:),[0 1]); colormap hot;
    UCbar(1) = colorbar; set(UCbar(1),'ytick',[0 0.5 1],'position',get(UCbar(1),'position')-[0.01 0 0 0]);
    set(UCbar(1),'fontsize',8);
    set(gca,'ytick',[]);
    set(gca,'fontsize',8);
    delete(axes_Uweights(k));
    delete(axes_Uweights(1));
    axes_Uweights(1) = axes('Position',[left(1) bottom(1)+height+0.01 width*size(Uwarp{k},2)/max_x 0.05]);
    imagesc(UtemplateHelpWeights,[0 2]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'fontsize',8);
    weightsCbar(1) = colorbar;    
    set(weightsCbar(1),'ytick',[ 1 2],'position',get(weightsCbar(1),'position')-[0.01 0 0 0]);
    set(weightsCbar(1),'fontsize',8);
    
    if (render_video(3+k))
        grabVideoFrames(myfig,times(3+k)*30,['render/video_feature_matrices_warped_averaging' num2str(k-1) '.avi']);
    end
end

delete(h_line);
delete(axes_U(1));
delete(axes_Uweights(1));

load motionTemplates_4cartwheels_iteration1_b
max_x = 0;
for k=1:length(U_out)
    max_x = max(max_x,size(U_out{k},2));
end
for k=1:length(U)
    axes_U(k) = axes('position',[left(k) bottom(k) width*size(U_out{k},2)/max_x height]);
    imagesc(U_out{k}(features_select,:),[0 1]); colormap hot;
    UCbar(k) = colorbar; set(UCbar(k),'ytick',[0 0.5 1],'position',get(UCbar(k),'position')-[0.01 0 0 0]);
    set(UCbar(k),'fontsize',8);
    set(gca,'ytick',[]);
    set(gca,'fontsize',8);
    axes_Uweights(k) = axes('Position',[left(k) bottom(k)+height+0.01 width*size(U_out{k},2)/max_x 0.05]);
    imagesc(Uweights{k},[0 2]);
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    set(gca,'fontsize',8);
    weightsCbar(k) = colorbar;    
    set(weightsCbar(k),'fontsize',8);
    set(weightsCbar(k),'ytick',[ 1 2],'position',get(weightsCbar(k),'position')-[0.01 0 0 0]);
    if (render_video(7+k))
        grabVideoFrames(myfig,times(7+k)*30,['render/video_motion_templates_iteration1_' num2str(k) '.avi']);
    end
end
