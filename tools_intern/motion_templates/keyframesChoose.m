function [keyframes,keyframesIndex] = keyframesChoose(motionTemplateReal,motionTemplateWeights,par)

feature_set = par.feature_set;
feature_set_ranges = par.feature_set_ranges;
if (~iscell(feature_set))
    feature_set = {feature_set};
end
if (~iscell(feature_set_ranges))
    feature_set_ranges = {feature_set_ranges};
end

param.thresh_lo = par.thresh_lo;
param.thresh_hi = par.thresh_hi;
%param.thresh_lo = 0;
%param.thresh_hi = 1;
param.visBool = 0;
param.visReal = 0;
param.visBoolRanges = 1;
param.visRealRanges = 0;
param.feature_set_ranges = feature_set_ranges;
param.feature_set = feature_set;
param.flag = 0;
[motionTemplate,motionTemplateWeights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);

if par.conv == 1
    d = size(motionTemplate,1);
    motionTemplateConv = [0.5*ones(d,1) motionTemplate 0.5*ones(d,1)];
    motionTemplateConv = conv2(motionTemplateConv,[1 1 1]/3);
    motionTemplateConv = motionTemplateConv(:,3:end-2);
    param.thresh_lo = 0;
    param.thresh_hi = 1;
    [motionTemplateConv,motionTemplateWeights] = motionTemplateBool(motionTemplateConv,motionTemplateWeights,param);
    motionTemplate = motionTemplateConv;    
end


num_frames = size(motionTemplate,2);
num_ranges = length(feature_set_ranges);

borderSuppressPercent = 0.2;
hann_length = 2*ceil(borderSuppressPercent*num_frames);
hann_window = hann(hann_length)';
score_window = [hann_window(1:hann_length/2) ones(1,num_frames-hann_length) hann_window(hann_length/2+1:end)];

num_black_entries = zeros(num_ranges,num_frames);
num_white_entries = zeros(num_ranges,num_frames);
scores = zeros(num_ranges,num_frames);
for i=1:num_ranges
    num_features = length(feature_set_ranges{i});
    num_black_entries(i,:) = sum(motionTemplate(feature_set_ranges{i},:)==0,1);
    num_white_entries(i,:) = sum(motionTemplate(feature_set_ranges{i},:)==1,1);
%     num_black_entries = zeros(1,num_frames);
%     num_white_entries = zeros(1,num_frames);
%     for k=1:num_frames
%         num_black_entries(k) = length(find(motionTemplate(feature_set_ranges{i},k)==0));
%         num_white_entries(k) = length(find(motionTemplate(feature_set_ranges{i},k)==1));
%     end
%    score = (2*num_white_entries + num_black_entries)/num_features;
    scores(i,:)  = (2*num_white_entries(i,:) + num_black_entries(i,:))/num_features;
    scores(i,:)  = scores(i,:).*score_window;
end

scores_help = scores;
keyframes = zeros(1,par.keyframesNumMax);
keyframesIndex = zeros(1,par.keyframesNumMax);
counter = 0;
while (counter<par.keyframesNumMax)
%     figure;
%     subplot(3,1,1); 
%     plot(scores_help(1,:));
%     set(gca,'ylim',[0 2]);
%     grid on;    
%     
%     subplot(3,1,2); 
%     plot(scores_help(2,:));
%     set(gca,'ylim',[0 2]);
%     grid on;    
%     
%     subplot(3,1,3); 
%     plot(scores_help(3,:));
%     set(gca,'ylim',[0 2]);
%     grid on;    
% 
%     set(gcf,'pos',[40   463   560   420]);
%     drawnow;

    [maxRows,I_frame] = max(scores_help,[],2);
    [currentScoreMax,I_feature_set] = max(maxRows);
        
    if (currentScoreMax<par.keyframesScoreMin)
        break;
    end
    
    counter = counter+1;
    keyframes(counter) = I_frame(I_feature_set);
    keyframesIndex(counter) = I_feature_set;
    
    ind = keyframesIndex(counter);
    
    I_left = max(I_frame(I_feature_set)-par.keyframeMinDist,1);
    I_right = min(I_frame(I_feature_set)+par.keyframeMinDist,num_frames);
    while (I_left > 1) & (scores_help(ind,I_left)>=scores_help(ind,I_left-1))
        I_left = I_left-1;
    end
    while (I_right < num_frames) & (scores_help(ind,I_right)>=scores_help(ind,I_right+1))
        I_right = I_right+1;
    end
    scores_help(ind,I_left:I_right) = 0;
end
keyframes = keyframes(1:counter);
keyframesIndex = keyframesIndex(1:counter);
[keyframes,I] = sort(keyframes);
keyframesIndex = keyframesIndex(I);
    
if (par.vis)
    figure;
    for i=1:num_ranges
        subplot(4,num_ranges,i+0*num_ranges); 
        imagesc(motionTemplate(feature_set_ranges{i},:),[0 1]); colormap gray; drawnow;
        h=title(feature_set{i});
        set(h,'interpreter','none');
        
        subplot(4,num_ranges,i+1*num_ranges); plot(num_black_entries(i,:)); 
        title('number of black entries');
        if (size(num_black_entries,2)>1) 
            set(gca,'xlim',[1 size(num_black_entries,2)]); 
        end
        set(gca,'ylim',[0 num_features]); 
        
        subplot(4,num_ranges,i+2*num_ranges); plot(num_white_entries(i,:)); 
        title('number of white entries');
        if (size(num_white_entries,2)>1) 
            set(gca,'xlim',[1 size(num_white_entries,2)]); 
        end
        set(gca,'ylim',[0 num_features]); 
        
        subplot(4,num_ranges,i+3*num_ranges); plot(scores(i,:));
        title('score');
        if (size(scores,2)>1) 
            set(gca,'xlim',[1 size(scores,2)]); 
        end
        set(gca,'ylim',[0 2]);
        grid on;
        hold on;
        I_kf = find(keyframesIndex == i);
        plot(keyframes(I_kf),scores(i,keyframes(I_kf)),'red o');

        set(gcf,'pos',[20   10   1200   420]);
        drawnow;
    end
end


% par.vis = 1;
% par.num_candidates = 4;
% 
% %close all;
% 
% %category = 'cartwheelLHandStart1Reps';
% category = 'cartwheelLHandStart1Reps';
% 
% %feature_set = 'AK_upper';
% %feature_set = 'AK_lower';
% feature_set = 'AK_mix';
% 
% directory = ['S:\data_MoCap\MoCaDaDB\HDM\Training\_templates\templates_' feature_set '_1_40_30\'];
% load([directory 'template_' category '_' feature_set '_11of21_30.mat']);
% 
% use_small_DB = true;
% if (use_small_DB)
%     load(fullfile(VARS_GLOBAL.dir_root,basedir,'_indexes',['index_small_' feature_set '.mat']));
%     index = index_small;
%     DB_concat = features_load_concat(['DB_concat_small_' feature_set '.mat']);
% else
%     load(fullfile(VARS_GLOBAL.dir_root,basedir,'_indexes',['index_all_' feature_set '.mat']));
%     index = index_all;
%     DB_concat = features_load_concat(['DB_concat_all_' feature_set '.mat']);
% end
% 
% param.thresh_lo = 0.1;
% param.thresh_hi = 1-param.thresh_lo;
% param.vis = 0;
% param.flag = 0;
% [motionTemplate,motionTemplateWeights] = motionTemplateBool(motionTemplate,motionTemplateWeights,param);
%%%%%%%%%%%%%%%%%%%%%%%%%%
