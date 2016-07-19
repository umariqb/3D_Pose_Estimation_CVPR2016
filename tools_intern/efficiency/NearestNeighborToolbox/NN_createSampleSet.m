function [ handle ] = NN_createSampleSet(Values,TimeStamps,Attributes)

if ~isnumeric(Values)
    error('Values parameter has to be numeric and non complex!');
end

N = size(Values,2);

if ~exist('TimeStamps','var')
    TimeStamps = 1:N;
end

if ~isnumeric(TimeStamps)
    error('TimeStamps, if provided, have to be numeric');
end

if ~isnumeric(TimeStamps) || size(TimeStamps,2) ~= N  || size(TimeStamps,1) ~= 1
    error('TimeStamps, if provided, have to be a numeric 1xN matrix, where N is the number of samples!');
end

if ~exist('Attributes','var')
    Attributes = 1:N;
end

if ~isnumeric(Attributes) || size(Attributes,2) ~= N
    error('Attributes, if provided, have to be a numeric PxN matrix, where N is the number of samples!');
end

if any(any(isnan(TimeStamps)))
    error('No NaNs in TimeStamps allowed!');
end

if any(any(isnan(Values)))
    error('No NaNs in Values allowed!');
end

if any(any(isnan(Attributes)))
    error('No NaNs in Attributes allowed!');
end

m=cast(size(Values,1),'uint32');
n=cast(size(Values,2),'uint32');

handle = nn_wrapper('new','SampleSet',m,n,double(TimeStamps),double(Values),double(Attributes));

end

