function [d,status,N]=XM_get_data_jt(h, Channels, num_MTs);

% [d,status]=XM_get_data(h, Channels, MT_BeingPlotted);
%
% MTObj needs to be fully configured and started to call this function.
%
% Input variables:
%  h = handle to MTObj
%  Channels = number of Channels of data to retrieve 
%                     defined by operation mode, Calibrated data = 10, Euler angles = 3, Matrix = 9, Quaternion = 4 channels
%  MT_BeingPlotted = MTx on Xbus to retrieve data from (i.e. 1,2,.. etc)
%
% Output variables:
% d = output data vector
% status = status returned by MTObj, use MT_return_error to display
%
% [events not supported by MATLAB], polling used with internal MTObj buffer
%
% Xsens Technologies B.V., 2002-2007
% v.2.8.4

% Check to see if number of input arguments is correct
if nargin==3, % error in "Channels" input is not handled here....
    if ~ishandle(h),
        error('The HANDLE to the Motion Tracker Object (MTObj) must be passed to this function');
    end
else
    error('too many or too few input arguments')
end

N = 0; % number of obtained samples
BufferMax = 256; % defined in MTObj, see documentation
d=zeros(1,Channels*num_MTs+1); % init d
status=0; % reset for each new sample

% read data from MTObj using the local MTObj buffer. This way you can make
% sure that no data will be lost even when using polling, at least if
% Matlab calls MTObj within 256 samples (i.e. within 2.56 seconds when sampled @ 100 Hz)for i = 1:BufferMax,

% obtain all samples from MTObj buffer
for i = 1:BufferMax,
    if Channels == 10, % Determine which data to retrieve from MTObj
        [arg1,arg2] = XM_GetCalibratedData(h,0); % get calibrated data from local buffer
    else
        [arg1,arg2] = XM_GetOrientationData(h,0); % get orientation data from local buffer
    end
%     arg1=double(arg1); % convert to double
    if arg1==1,
        arg2=double(arg2);% arg1 remains zero, d will be unassigned, i.e. the intial value
        N = N + 1;
        d(N,:)=arg2; % only use the first sensor attched to XM
        status=arg1;
    elseif arg1>1,% no data to return or error has occurred
        status=arg1;% return errorcode
        d=zeros(1:size(arg2,2));
        break % exit function
    elseif arg1==0,
        break % finished reading buffer, or no data available, return default values
    end
end

