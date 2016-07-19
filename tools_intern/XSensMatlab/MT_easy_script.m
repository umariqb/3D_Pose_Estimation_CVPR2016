% Press "F5" to run the script and then answer the questions.
% You should get a single sample from the MTObj DLL with both inertial and
% magnetic data as well as Euler-angles 3D orientation data.

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
h.MT_SetCOMPort(COMport,baudrate);

% request device information from MTi or MTx
[DeviceID] = h.MT_QueryMotionTrackerB

% request calibrated inertial and magnetic data along with orientation data
h.MT_SetCalibratedOutput(1);
% request orientation data in Euler-angles
h.MT_SetOutputMode(1);

% ask if the user want to change some optional settings
[heading] = h.MT_GetMotionTrackerHeading
St=input(['What heading would you like to use? <',num2str(heading),'>'],'s');
if ~isempty(St), acceptchanges = 1; heading=str2num(St); 
    h.MT_SetMotionTrackerHeading(heading); end
[location] = h.MT_GetMotionTrackerLocation
St=input(['What location would you like to use? <',num2str(location),'>'],'s');
if ~isempty(St), acceptchanges = 1; location=str2num(St); 
    h.MT_SetMotionTrackerLocation(location); end
[samplefreq] = h.MT_GetMotionTrackerSampleFrequency
St=input(['What samplefreq would you like to use? <',num2str(samplefreq),'>'],'s');
if ~isempty(St), acceptchanges = 1; samplefreq=str2num(St); 
    h.MT_SetMotionTrackerSampleFrequency(samplefreq); end

% assume the user does NOT want to store the settings in non-volatile
% memory!
acceptchanges = 0;
if acceptchanges == 1,
    % call MT_SaveToMTS, this will store all changed settings in
    % non-volatile memory
    h.MT_SaveToMTS(DeviceID);
end

% That's it!
% MTObj is ready to start processing the data stream from the MTi or MTx
h.MT_StartProcess; % start processing data

% wait short moment for object to read data from COM-port
pause(0.1);

% retrieve the data
[arg1,inertialData] = MT_GetCalibratedData(h,1); % get latest calibrated data from buffer
[arg1,eulerAngle] = MT_GetOrientationData(h,1); % get latest orientation data from buffer

% if data retrieved succesfully (arg1=1)
if arg1==1,
    status= double(arg1) % MTObj status (can be converted to double for easy use in Matlab)
    inertialData = double(inertialData) % data values (can be converted to double for easy use in Matlab)
    eulerAngle = double(eulerAngle) % data values (can be converted to double for easy use in Matlab)
end

% stop processing before removing object
h.MT_StopProcess;

% when finished with MTObj, release it from the MATLAB workspace
delete(h); % release MTObj COM-object
clear h;
clear all;