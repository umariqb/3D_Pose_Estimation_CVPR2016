function PrecisionRecall = BK_CompareFeatureSets(Sets)

count=1;
PrecisionRecall=struct('Precision',[],'Recall',[]);
global VARS_GLOBAL;

% features_precompute;
% create_DB_info;
% DB_index_precompute;

numSets=size(Sets)

for i=1:numSets(2)
    VARS_GLOBAL.feature_sets=Sets(i)
    motionTemplatePrecomputeBatch
%   motionClass='cartwheelLHandStart1Reps';
    motionClass='walk2StepsLstart';
%   motionClass='jumpingJack1Reps';
    [hits,C,D,delta] = motionTemplateIterativeWeighted(VARS_GLOBAL.DB,motionClass);
    [TMP1,TMP2]=BK_getPrecisionRecall(VARS_GLOBAL.DB,motionClass,hits);
    PrecisionRecall(count).Precision=TMP1(:,1);
    PrecisionRecall(count).Recall=TMP2(:,1);
    count=count+1;
end;