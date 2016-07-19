function PrecisionRecall = BK_PrecisionRecall(start,step,endv)

count=1;
PrecisionRecall=struct('Precision',[],'Recall',[]);
for i=start:step:endv
    global VARS_GLOBAL;
    VARS_GLOBAL.treshold=i;
    BK_RetrievalPrecompute;
%    motionClass='cartwheelLHandStart1Reps';
    motionClass='walk2StepsLstart';
%     motionClass='jumpingJack1Reps';
    [hits,C,D,delta] = motionTemplateIterativeWeighted(VARS_GLOBAL.DB,motionClass);
    [TMP1,TMP2]=BK_getPrecisionRecall(VARS_GLOBAL.DB,motionClass,hits);
    PrecisionRecall(count).Precision=TMP1(:,1);
    PrecisionRecall(count).Recall=TMP2(:,1);
    count=count+1;
end;