h=actxserver('MotionTracker.FilterComponent');

% MT_SetCOMPort(short nPort ,int nBaudrate);
% default: nPort=1, nBaudrate=115200
COMport     = 3;
baudrate    = 115200;
h.XM_SetCOMPort(COMport,baudrate);

% XM_QueryXbusMasterB(short *nNumSensors, BSTR * bstrDeviceIDs);
[num_MTs,DIDs] = h.XM_QueryXbusMasterB;
if num_MTs==0,
    error('Xbus Master not found or no sensors found by Xbus Master...exiting.')
end

% XM_SetFilterSettings(BSTR bstrSensorID, float fGain, short nCorInterval,
% float fRho);
% default: fGain=1.0, nCorInterval=1, fRho=1.0
for i=1:num_MTs,
    MTx_DIDs{i} = DIDs((i*8 - 7):(i*8)); 
    h.XM_SetFilterSettings(char(MTx_DIDs(i)),1.0,1,1.0);
end

% XM_SetCalibratedOutput(short nEnabled);
% 0 – Disabled (default)
% 1 – Enabled
h.XM_SetCalibratedOutput(1);

% XM_SetOutputMode(short nMode);
% 0 - Quaternion (default)
% 1 - Euler
% 2 - Rotation matrix
h.XM_SetOutputMode(0);

% XM_SetTimeout(short nTimeout);
% 1<nTimeout<120, default: 3 
h.XM_SetTimeout(3);

% XM_SetTimeStampOutput(short nEnabled);
% 0 - Disabled (default)
% 1 - Enabled
h.XM_SetTimeStampOutput(1);

% % XM_SetDoAMD(BSTR bstrDeviceID, short nDoAMD);
% % nDoAMD=0 - Disabled (default)
% % nDoAMD=1 - Enabled
% for i=1:num_MTs,
%   h.XM_SetDoAMD(char(MTx_DIDs(i),0);
% end

% % XM_SetMotionTrackerHeading(BSTR bstrDeviceID, float fHeading);
% for i=1:num_MTs,
%     h.XM_SetMotionTrackerHeading(char(MTx_DIDs(i)), fHeading);
% end

% XM_SetMotionTrackerLocation(BSTR bstrDeviceID, short nLocation);
% for i=1:num_MTs,
%     h.XM_SetMotionTrackerLocation(char(MTx_DIDs(i)), fHeading);
% end

% XM_SaveToMTS(BSTR bstrDeviceID);
% for i=1:num_MTs,
%     h.XM_SaveToMTS(char(MTx_DIDs(i)));
% end

h.XM_StartProcess; %-------------------------------------------------------

% % [float *fGain, short *nCorInterval, float *fRho]=XM_GetFilterSettings(BSTR bstrDeviceID);
% for i=1:num_MTs,
%     [fGain, nCorInterval, fRho]=XM_GetFilterSettings(char(MTx_DIDs(i)));
% end

% % int nBaudrate=MT_GetMotionTrackerBaudrate;
% nBaudrate=h.MT_GetMotionTrackerBaudrate;

% % int nSampleFrequency=MT_GetMotionTrackerSampleFrequency;
% nSampleFrequency=h.MT_GetMotionTrackerSampleFrequency;

% % XM_ResetOrientation(short nResetType, short bSaveAfterStop);
% % nResetType=0 – Heading reset
% % nResetType=1 – Global reset
% % nResetType=2 – Object reset
% % nResetType=3 – Align (Object followed by Heading reset)
% % bSaveAfterStop=0 - Do not save to memory (default)
% % bSaveAfterStop=1 - Save to memory
% h.XM_ResetOrientation(nResetType, bSaveAfterStop);

% % float fHeading=XM_GetMotionTrackerHeading(BSTR bstrDeviceID);
% fLocation=h.XM_GetMotionTrackerHeading(bstrDeviceID);

% % float fHeading=XM_GetMotionTrackerLocation(BSTR bstrDeviceID);
% fLocation=h.XM_GetMotionTrackerLocation(bstrDeviceID);

% [short nRetVal, VARIANT pfOutputArray]=XM_GetOrientationData(nLatest);
% nLatest=0 - return latest calculated orientation date (default)
% nLatest=1 - use the buffer (this way all data can be retrieved from the
% object with consecutive calls to XM_GetOrientationData)
%
% nRetVal=0 – No new data calculated (No Error)
% nRetVal=1 – New data available
% nRetVal=2 – No data on COM port
% nRetVal=3 – No device ID received from sensor
% nRetVal=4 – Incomplete data received (Connection lost)
% nRetVal=5 – Checksum error in data from sensor
% nRetVal=6 – COM port could not be opened
[nRetVal, pfOutputArray]=h.XM_GetOrientationData(0);

%[short *nRetVal, VARIANT *pfOutputArray]=XM_GetCalibratedData(short nLatest);
[nRetVal2, pfOutputArray2]=h.XM_GetCalibratedData(0);

% h.XM_StopProcess(); %------------------------------------------------------

