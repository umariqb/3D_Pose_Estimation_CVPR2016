% Press "F5" to run the script and then answer the questions.
% You should get a single sample from the MTObj DLL with both inertial and
% magnetic data as well as Euler-angles 3D orientation data.
%
% This script is adapted to work with the Xbus Master and will call the XM
% functions of MTObj rather than the MT functions which should be used for
% the stand-alone MTi or MTx.

% To view all the methods of the MTObj software component;
% methodsview(h) % h = handle to the object

% Xsens Technologies B.V., 2002-2007
% v.2.8.4 (SDK 2.8.3)

% set up instance of MTObj in MATLAB
h=actxserver('MotionTracker.FilterComponent');

St=input(['What COM-port is your MTi or MTx connected to? <1>'],'s');
COMport = str2num(St);
% assume default value for baud rate, but this can also be set
baudrate = 115200;

% call MT_SetCOMPort is required, unless using COM 1
h.XM_SetCOMPort(COMport,baudrate);

% Query XM for DeviceID of connected MTx's
[num_MTs,DIDs]= h.XM_QueryXbusMasterB
if num_MTs==0,
    error('Xbus Master not found or no sensors found by Xbus Master...exiting.')
end

% setup individual settings for each MTx on Xbus
for i=1:num_MTs,
    % Note: Creating Cell array of device IDs for use in Set functions below
    MTx_DIDs{i} = DIDs((i*8 - 7):(i*8)); 
    % Set the settings you need, here the FilterSettings are used as
    % example
    h.XM_SetFilterSettings(char(MTx_DIDs(i)),1.0,1,1.0);
end

% request calibrated inertial and magnetic data along with orientation data
h.XM_SetCalibratedOutput(1);
% request orientation data in Euler-angles
h.XM_SetOutputMode(1);

% That's it!
% MTObj is ready to start processing the data stream from the MTi or MTx
h.XM_StartProcess; % start processing data

% wait short moment for object to read data from COM-port
pause(0.1);

% retrieve the data
[arg1,inertialData] = XM_GetCalibratedData(h,1); % get latest calibrated data from buffer
[arg1,eulerAngle] = XM_GetOrientationData(h,1); % get latest orientation data from buffer

% if data retrieved succesfully (arg1=1)
if arg1==1,
    status= double(arg1) % MTObj status (can be converted to double for easy use in MATLAB)
    inertialData = double(inertialData) % data values (can be converted to double for easy use in MATLAB)
    eulerAngle = double(eulerAngle) % data values (can be converted to double for easy use in MATLAB)
end

% stop processing before removing object
h.XM_StopProcess;

% when finished with MTObj, release it from the MATLAB workspace
delete(h); % release MTObj COM-object
clear h;
clear all;

