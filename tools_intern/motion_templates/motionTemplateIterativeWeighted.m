function [hits,C,D,delta] = motionTemplateIterativeWeighted(search_DB, pattern_DB, category, showGraphs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test of iterative motion template generation with different reference motions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global VARS_GLOBAL;

if nargin < 4
    showGraphs = true;
end
% close all hidden;
%clear all;
 
% 1, 2, 3, 4, 8
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);

%%%%%%%% vorkonfigurierte Datenbanken
%DB_name = 'CMU_180';
%DB_name = 'CMU_60';
%DB_name = 'CMU_20';
%DB_name = 'HDM_MC_10';
%DB_name = 'HDM_MC';
% DB_name = 'HDM_MCE';
% DB_name = 'HDM05_cut_c3d';
% DB_name = 'HDM05_cut_amc_all';
%DB_name = 'HDM_MCT';
%DB_name = 'HDM_Uncut';
%DB_name = 'HDM_MC_BD';
%DB_name = 'HDM_MCE_BD';
%DB_name = 'HDM_MCE_BD_walkRight';
%DB_name = 'HDM_MCT_BD';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%files = [1:2:21];
files = [1 5 7 16];
% category = 'hopRLeg3hops';

%category = {'cartwheelLHandStart1Reps','jumpingJack1Reps'};
%files = {[1:10],[1:4]};

basedir = fullfile(pattern_DB,'cut_amc');
basedir_features = fullfile(pattern_DB,'_features','');
basedir_templates = fullfile(pattern_DB,'_templates','');
% basedir = fullfile('HDM05_cut_c3d','');
% basedir_features = fullfile('HDM05_cut_c3d_constSkel','_features','');
% basedir_templates = fullfile('HDM05_cut_c3d_constSkel','_templates','');
% basedir = fullfile('test_cut_c3d_mini','');
% basedir_features = fullfile('test_cut_c3d_mini','_features','');
% basedir_templates = fullfile('test_cut_c3d_mini','_templates','');

%basedir_features = fullfile('HDM', 'Uncut','_features','');

settings = ['5_0_' sampling_rate_string];   % strategy 5

feature_set_ranges = {1:6};
feature_set_array={VARS_GLOBAL.feature_sets};
% feature_set_array = {{'BK_torque'}};
% feature_set_ranges = {1:14,15:26,27:39};
% feature_set_array = {{'AK_upper','AK_lower','AK_mix'}};

retrieve = true;
%retrieve = false;
%compute_template = true;
compute_template = false;

%flipLR = true;
flipLR = false;

deltas = cell(1,length(feature_set_array));
for j=1:length(feature_set_array)
    feature_set = feature_set_array{j};
    
    if (compute_template)
        % Generate Templates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        parameter.visCost            = 0;
        parameter.visWarp            = 0;
        parameter.visTemplate        = 0;
        parameter.visIterations      = 0;
        parameter.visLastIteration   = 0;
        parameter.visStatistics      = 0;
        parameter.visVrepW           = 0;
        parameter.visTemplateFinal   = 0;
        parameter.downsampling_fac   = downsampling_fac;
        parameter.VrepWoverlapFactor = 0.4; % parameter.VrepWoverlapFactor = 0 yields same behavior as "classical" connected components approach
        parameter.templateComputationStrategy = 5; % should remain set to "5"
        parameter.basedir = basedir_features; 
        parameter.category = category;
        parameter.files = files;
        parameter.feature_set = feature_set;
        parameter.iter_max           = 10;
        parameter.iter_thresh        = 0.005;
        %         parameter.iter_max           = 60;
        %         parameter.iter_thresh        = 1e-16;
        
        parameter.conjoin = 0;
        
        tic
        [motionTemplateReal,motionTemplateWeights] = motionTemplateGenerateDTWIterative(parameter);
        toc
    else
        [motionTemplate,motionTemplateWeights,motionTemplateKeyframes,parameter] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
        motionTemplateReal = motionTemplate;
        motionTemplateWeights = motionTemplateWeights;
    end
    
    if isempty(motionTemplateReal)
        disp(['   No motion template found for "' category '"!']);
        hits = []; C = []; D= []; delta = [];
        return;
    end

    if (flipLR)
        motionTemplateReal = motionTemplateFlip(motionTemplateReal);
    end

% load DB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       [DB,filenames] = features_decode_category(basedir_features,{'cartwheelLHandStart1Reps','cartwheelLHandStart2Reps','walk2StepsRstart','jogLeftCircle4StepsRstart'},feature_set,{},downsampling_fac);
%     [DB, filenames] = features_decode_description(basedir_features,'HDM_uncut',feature_set,{'5-3'},4);
%     [DB,filenames] = features_decode_subdir({'AMC\sports\gymnastics'},feature_set,false,{1},downsampling_fac);
%     [DB,filenames] = features_decode_category(basedir_features,{'cartwheelLHandStart1Reps','jumpingJack1Reps','cartwheelLHandStart2Reps','grabHighR','skier1RepsLstart','grabMiddleR','walk2StepsLstart','grabLowR','jogLeftCircle4StepsRstart','grabFloorR'},feature_set,{},downsampling_fac);
%     [DB,filenames] = features_decode_category(basedir_features,{'cartwheelLHandStart1Reps','jumpingJack1Reps','cartwheelLHandStart2Reps','squat1Reps'},feature_set,{},downsampling_fac);
%
   DB_concat = DB_index_load(search_DB,feature_set,downsampling_fac); % vorkonfigurierte DBs

%     DB_concat = features_concatenate(DB,filenames,0);    % parameter 3: 0   -> simple concatenation, treat files as "continuous transition"
                                                         %              n>0 -> insert n NaN-columns between files (use n=2)
    motionDatabase = DB_concat.features;


    % Retrieval %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% 2) Bool retrieval with thresholded template
    param.thresh_lo = 0.1;
    param.thresh_hi = 1-param.thresh_lo;
    param.visBool = 0;
    param.visReal = 0;
    param.visBoolRanges = showGraphs;
    param.visRealRanges = showGraphs;
    param.feature_set_ranges = feature_set_ranges;
    param.feature_set = feature_set;
    param.flag = 0;
    [motionTemplateBoolean,weights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);    
    
    if (retrieve)
        parameter.visCost      = showGraphs;
        parameter.match_numMax = 100;
        parameter.match_thresh = 0.175;
        parameter.match_endExclusionForward = 0.1;
        parameter.match_endExclusionBackward = 0.5;
        parameter.match_startExclusionForward = 0.5;
        parameter.match_startExclusionBackward = 0.1;
        parameter.expandV = 1;
        [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(motionTemplateBoolean,weights,motionDatabase,ones(1,size(motionDatabase,2)),parameter,...
            [1 1 2],[1 2 1],[1 1 2]);
        %                [1 1 2 1 3],[1 2 1 3 1],[1 1 2 1 3]);
        %                                                             [1 0 2],[1 1 1],[1 1 2]);
        %                                                             [1 0 1],[1 1 0],[1 1 1]);
        %                                                              [0 1 2 3 4 5],[1 1 1 1 1 1],[1 sqrt(2) sqrt(5) sqrt(10) sqrt(17) sqrt(26)]);
        if showGraphs
            showDeltaClickable(delta,DB_concat,feature_set);
        end
        hits = hits_DTW_postprocess(hits,DB_concat,downsampling_fac);
        if showGraphs
            showHitsClickable(hits,DB_concat,feature_set,feature_set_ranges,downsampling_fac,size(DB_concat.features,2));
            showHitsClickableRanking(hits,DB_concat,feature_set,feature_set_ranges,downsampling_fac);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



        % % Precision-recall diagram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % figure;
        % [precision,recall] = precision_recall(category,hits);
        % plot(100*recall,100*precision,'blue o');
        % set(gca,'xlim',[0 100],'ylim',[0 100]);
        % ylabel('precision');
        % xlabel('recall');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 
        %     [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(T{k},weights{k},motionDatabase,ones(1,size(motionDatabase,2)),parameter,...
        %                                                              [-1 0 -1],[-1 -1 0]);
        % %    [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(T{k},motionTemplateWeights,motionDatabase,ones(1,size(motionDatabase,2)),parameter);
        % %    [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(T{k},ones(1,size(T{k},2)),motionDatabase,ones(1,size(motionDatabase,2)),parameter);
        %     showDeltaClickable(delta,DB_concat);
        %     hits = hits_DTW_postprocess(hits,DB_concat);
        %     showHitsClickable(hits);
        % % Precision-recall diagram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % figure;
        % [precision,recall] = precision_recall(category,hits);
        % plot(100*recall,100*precision,'blue o');
        % set(gca,'xlim',[0 100],'ylim',[0 100]);
        % ylabel('precision');
        % xlabel('recall');
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
%        title(['thresh_lo = ' num2str(thresh_lo(k)) ', sampling rate = ' sampling_rate_string]);
