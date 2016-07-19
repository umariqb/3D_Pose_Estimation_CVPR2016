function obj = changeObjFrameRate(obj,newSamplingRate)

oldSamplingRate = obj.samplingRate;

if oldSamplingRate ~= newSamplingRate
    obj.samplingRate = newSamplingRate;

    nrOfFrames = size(obj.data,2);
    newSamp  = round(1:oldSamplingRate/newSamplingRate:nrOfFrames);
    obj.data = obj.data(:,newSamp);

    if isfield(obj,'alpha') && size(obj.alpha,2)==nrOfFrames
        obj.alpha = obj.alpha(:,newSamp);
    end
end