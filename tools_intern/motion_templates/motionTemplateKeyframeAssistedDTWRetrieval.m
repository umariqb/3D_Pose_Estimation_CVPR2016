function hits = motionTemplateKeyframeAssistedDTWRetrieval(DB_name, category, showGraphs)
% close all;

global VARS_GLOBAL;

showRunningTime = false;

if nargin < 1
%DB_name = 'CMU_180';
%DB_name = 'CMU_60';
%DB_name = 'CMU_20';
%DB_name = 'HDM_MC_10';
% DB_name = 'HDM_MCH';
% DB_name = 'HDM05_cut_amc';
% DB_name = 'HDM05_cut_c3d';
%DB_name = 'HDM_MC';
%DB_name = 'HDM_MCE';
%DB_name = 'HDM_MCT';
%DB_name = 'HDM_Uncut';
%DB_name = 'HDM_MC_BD';
%DB_name = 'HDM_MCE_BD';
%DB_name = 'HDM_MCE_BD_walkRight';
%DB_name = 'HDM_MCT_BD';
end

hits=[];
if nargin < 3
    showGraphs = true;
end

basedir_templates = fullfile(DB_name,'_templates','');
% basedir_templates = fullfile('HDM','Training','_templates','');
downsampling_fac = 4;
sampling_rate_string = num2str(120/downsampling_fac);
% settings = ['5_0_' sampling_rate_string '_conjoin'];
settings = ['5_0_' sampling_rate_string];

%DB_index_precompute;

feature_set = {'AK_upper','AK_lower','AK_mix'};
%feature_set = {'AK_upper','AK_lower'};
%feature_set = {'AK_upper','AK_mix'};
%feature_set = {'AK_lower','AK_mix'};
%feature_set = {'AK_upper'};
%feature_set = {'AK_lower'};
%feature_set = {'AK_mix'};

% category = 'cartwheelLHandStart1Reps';
%category = 'cartwheelLHandStart2Reps';
% category = 'walk2StepsRstart';
% category = 'jogLeftCircle4StepsRstart';
%category = 'grabHighR';
%category = 'skier1RepsLstart';
%category = 'grabMiddleR';
%category = 'jumpingJack1Reps';
%category = 'grabLowR';
% category = 'lieDownFloor';
%category = 'grabFloorR';

%category = 'hopBothLegs1hops';
%category = 'hopBothLegs2hops';
%category = 'hopBothLegs3hops';
%category = 'hopRLeg1hops';
%category = 'sitDownKneelTieShoes';
%category = 'squat1Reps';
%category = 'squat3Reps';
%category = 'punchRFront1Reps';
%category = 'punchRSide1Reps';
%category = 'staircaseUp3Rstart';
%category = 'sitDownTable';
%category = 'turnLeft';
%category = 'turnRight';
%category = 'jumpingJack1Reps';
%category = 'jumpDown';
%category = 'sneak4StepsLStart';
%category = 'kickRFront1Reps';
%category = 'kickRSide1Reps';
%category = 'rotateArmsRForward1Reps';
%category = 'throwSittingHighR';
%category = 'throwStandingHighR';
%category = 'rotateArmsRBackward1Reps';
%category = 'rotateArmsBothBackward1Reps';
%category = 'rotateArmsBothForward1Reps';
%category = 'rotateArmsRForward1Reps';
%category = 'rotateArmsBothForward3Reps';
%category = 'rotateArmsRForward3Reps';
%category = 'shuffle4StepsLStart';
%category = 'sitDownChair';
%category = 'sitDownTable';
%category = 'sitDownKneelTieShoes';
%category = 'staircaseDown3Rstart';
%category = 'staircaseUp3Rstart';
%category = 'jogRightCircle4StepsRstart';
%category = 'clap5Reps';
%category = 'clapAboveHead1Reps';
%category = 'elbowToKnee1RepsRelbowStart';
%category = 'elbowToKnee1RepsLelbowStart';
%category = 'walkLeft3Steps';
%category = 'walkRight3Steps';
% category = 'walkRightCrossFront3Steps';

parameter.feature_set_ranges = {1:14,15:26,27:39};

%flipLR = true;
flipLR = false;

retrieveKeyframeAssistedDTW = true;
%retrieveKeyframeAssistedDTW = false;

%retrievePlainDTW = true;
retrievePlainDTW = false;

if (iscell(feature_set))
    feature_set_name = '';
    for i=1:length(feature_set)
        if (i==1)
            feature_set_name = feature_set{i};
        else
            feature_set_name = [feature_set_name '_' feature_set{i}];
        end
    end
else
    feature_set_name = feature_set;
end     

%%%%%% load DB and indexes
if (retrieveKeyframeAssistedDTW)
    [DB_concat,indexArray] = DB_index_load(DB_name,feature_set,downsampling_fac);
else
    DB_concat = DB_index_load(DB_name,feature_set,downsampling_fac); % don't need index
end

%%%% load and threshold motion template
[motionTemplateReal,motionTemplateWeights] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);
feature_set_ranges = parameter.feature_set_ranges;
if (flipLR)
    motionTemplateReal = motionTemplateFlip(motionTemplateReal);
end

% motionTemplateReal = motionTemplateReal(:,25:end);
% motionTemplateWeights = motionTemplateWeights(:,25:end);

param.thresh_lo = 0.1;
param.thresh_hi = 1-param.thresh_lo;
param.visBool = 0;
param.visReal = 0;
param.visBoolRanges = showGraphs;
param.visRealRanges = showGraphs;
param.feature_set_ranges = feature_set_ranges;
param.feature_set = feature_set;
param.flag = 0;
[motionTemplate,weights] = motionTemplateBool(motionTemplateReal,motionTemplateWeights,param);

if (retrieveKeyframeAssistedDTW)
    %%% determine keyframes
%     settings_KC = ['5_0_' sampling_rate_string '_all_training'];
    [motionTemplateReal_KC,motionTemplateWeights_KC] = motionTemplateLoadMatfile(basedir_templates,category,feature_set,settings);

    if isempty(motionTemplateReal_KC)
        disp(['   No motion template found for "' category '"!']);
        return;
    end
    par.vis = showGraphs;
    par.keyframesNumMax = 2;
    par.keyframesScoreMin = 0.9;
    par.thresh_lo = 0.1;
    par.thresh_hi = 1-par.thresh_lo;
    par.conv = 1;
    par.keyframeMinDist = 10;
    par.feature_set_ranges = feature_set_ranges;
    par.feature_set = feature_set;
    par.keyframeMinDist = 5;
    %[motionTemplateKeyframes, motionTemplateKeyframesIndex] = keyframesChoose(motionTemplateReal_KC,motionTemplateWeights_KC,par);
    [motionTemplateKeyframes, motionTemplateKeyframesIndex] = keyframesChoose2(motionTemplateReal_KC,motionTemplateWeights_KC,par);
%    mismatch = ones(1,length(motionTemplateKeyframes));
    mismatch = zeros(1,length(motionTemplateKeyframes));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% use index to find portions of the database that contain the keyframes in a suitable sequence and relative distance
    %     K = length(motionTemplateKeyframes);
    %     keyframeList = cell(1,K);
    %     Q_fuzzy = motionTemplateConvertToFuzzyQuery(motionTemplate(:,motionTemplateKeyframes));
    %     for k=1:K
    %         keyframeList{k} = C_union_presorted_2xn(index.lists(Q_fuzzy{k})); % "fuzzy step": compute union of lists
    %     end
    %     maxKeyframeSep = 2*(motionTemplateKeyframes(end)-motionTemplateKeyframes(1)+1);
    %     extendLeft = 3*(motionTemplateKeyframes(1));
    %     extendRight = 3*(size(motionTemplate,2) - motionTemplateKeyframes(end));
    %     [segments0,framesTotalNum0,matchStart0,match0] = keyframeSequenceFind(keyframeList,maxKeyframeSep,extendLeft,extendRight,index);
    
    if (~isempty(motionTemplateKeyframes))
        maxKeyframeSep = 2*(motionTemplateKeyframes(end)-motionTemplateKeyframes(1)+1);
        extendLeft = 3*(motionTemplateKeyframes(1));
        extendRight = 3*(size(motionTemplate,2) - motionTemplateKeyframes(end));
        %    [segments,framesTotalNum,matchStart,match] = keyframeSequenceFindMultIndex(motionTemplate,[motionTemplateKeyframes; motionTemplateKeyframesIndex],maxKeyframeSep,extendLeft,extendRight,indexArray);
        tic
        [segments,framesTotalNum,matchStart,match] = keyframeSequenceFindMultIndexMismatch(motionTemplate,[motionTemplateKeyframes; motionTemplateKeyframesIndex; mismatch],maxKeyframeSep,extendLeft,extendRight,indexArray);    
        if showRunningTime
            toc
        end
        
        if (isempty(segments))
            disp('segments was empty.');
            return
        end
        
        [DB_cut,segments_cut] = featuresCut(DB_concat,segments,indexArray(1),framesTotalNum,2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        parameter.visCost      = showGraphs;
        parameter.match_numMax = 500;
        parameter.match_thresh = 0.06;
        parameter.match_endExclusionForward = 0.1;
        parameter.match_endExclusionBackward = 0.5;
        parameter.match_startExclusionForward = 0.5;
        parameter.match_startExclusionBackward = 0.1;
        parameter.expandV = 1;
        tic
        [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(motionTemplate,weights,DB_cut.features,ones(1,size(DB_cut.features,2)),parameter,...
            [1 1 2],[1 2 1],[1 1 2]);
        if showRunningTime
            toc
        end
        if ~isnan(min(delta)) && showGraphs
            showDeltaClickableSegments(delta,DB_cut,segments_cut,segments,feature_set,feature_set_ranges,downsampling_fac);
        end
        [hits_cut,hits] = hits_DTW_postprocessSegments(hits,DB_cut,segments_cut,DB_concat,segments);
        if ~isempty(hits_cut) && showGraphs
            showHitsClickable(hits_cut,DB_cut,feature_set,feature_set_ranges,downsampling_fac,size(DB_cut.features,2));
            showHitsClickableRankingSegments(hits_cut,DB_cut,feature_set,feature_set_ranges,downsampling_fac);
        end
    else
        disp('motionTemplateKeyframes was empty.');
    end
end

if (retrievePlainDTW)
    parameter.visCost      = 1;
    parameter.match_numMax = 500;
    parameter.match_thresh = 0.06;
    parameter.match_endExclusionForward = 0.1;
    parameter.match_endExclusionBackward = 0.5;
    parameter.match_startExclusionForward = 0.5;
    parameter.match_startExclusionBackward = 0.1;
    parameter.expandV = 1;

    tic
    [hits,C,D,delta] = motionTemplateDTWRetrievalWeighted(motionTemplate,weights,DB_concat.features,ones(1,size(DB_concat.features,2)),parameter,...
        [1 1 2],[1 2 1],[1 1 2]);
    toc
    showDeltaClickable(delta,DB_concat,feature_set,feature_set_ranges,downsampling_fac);
    hits = hits_DTW_postprocess(hits,DB_concat);
    showHitsClickable(hits,DB_concat,feature_set,feature_set_ranges,downsampling_fac,size(DB_concat.features,2));
    showHitsClickableRanking(hits,DB_concat,feature_set,feature_set_ranges,downsampling_fac);
end