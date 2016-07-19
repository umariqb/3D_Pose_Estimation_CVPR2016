function res=pushDBmats2NNwrapper(dbmats,featureSet,varargin)

switch nargin
    case 2
        split=true;
    case 3
        split=varargin{1};
    otherwise
        error('Wrong Num of Args\n');
end

if split

    res.SampleSetHandles=zeros(1,size(dbmats.motStartIDs,1));

    SampleSetData=extractFeatureSetFromDB(dbmats,featureSet);

    for mot=1:size(dbmats.motStartIDs,1)-1
        tmp = SampleSetData(:,dbmats.motStartIDs(mot):dbmats.motStartIDs(mot+1)-1);
        tmp(isinf(tmp))=0;
        tmp(isnan(tmp))=0;
        res.SampleSetHandles(mot)=NN_createSampleSet(tmp);
    end
    tmp = SampleSetData(:,dbmats.motStartIDs(mot+1):end);
    tmp(isinf(tmp))=0;
    tmp(isnan(tmp))=0;
    res.SampleSetHandles(end)=NN_createSampleSet(tmp);
else
    SampleSetData=extractFeatureSetFromDB(dbmats,featureSet);
    res.SampleSetHandles=NN_createSampleSet(SampleSetData); 
end

end