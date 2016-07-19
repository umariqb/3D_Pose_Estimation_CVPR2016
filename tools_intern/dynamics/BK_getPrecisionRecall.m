function [Precision,Recall]=BK_getPrecisionRecall(DB,motionClass,hits)


tmp=size(hits);
total=tmp(1);

for HIT=1:total
    correct=0;
    for hit=1:HIT
        findres=strfind(hits(hit).file_name,motionClass);
        if (~isempty(findres))
            correct=correct+1;
        end
    end
    %Precision
    Precision(HIT,1)=correct/HIT;
    %Recall
    Recall(HIT,1)=correct/5;
end

