function res=captureXsens(varargin)

%% captureXsens(varargin);
%
% Optional Input arguments
% 1. jointIDs - row vector defining the IDs of the captured joints (order
% is important)
% 2. videoCapture (default: false)
%
% example function call:
%   "XM_CaptureData_jt([4,18,9,21,28],false)"
%
% IMPORTANT: -----------------------------------------
% Press mouse button on figure to start capturing!
% Press "Q" to stop capturing and quit displaying!
% Pres "N" to switch to display next MTx connected on Xbus

% set default values if needed
DisplayMode             = 'caldata';
zoom_level_setting      = 2;
filterSettings_gain     = 1.0;
filterSettings_corr     = 1;
filterSettings_weight   = 1.0;

defaultValues               = {[],false};
nonemptyIdx                 = ~cellfun('isempty',varargin);
defaultValues(nonemptyIdx)  = varargin(nonemptyIdx);
[jointIDs,videoCapture]     = deal(defaultValues{:});

% set up MTObj
h=actxserver('MotionTracker.FilterComponent');

try
    % use try-catch to avoid the need to shutdown MATLAB if m-function fails (e.g. during debugging)
    % This is needed because MATLAB does not properly release COM-objects when
    % the m-function fails/crashes and the object is not explicitly released with "delete(h)"
    h.XM_SetTimeStampOutput(1);

    % call XM_SetCOMPort is required, unless using COM 1
    num_MTs = 0;
    COMport = 0;
    while (num_MTs==0 && COMport<12)
        COMport=COMport+1;
        if COMport==3
            baudrate=115200;
        else
            baudrate=460800;        
        end
        h.XM_SetCOMPort(COMport,baudrate);
        try
            fprintf('Scanning COMport %i... ',COMport);
            [num_MTs,DIDs]=h.XM_QueryXbusMasterB;
            fprintf('successful.\n');
        catch
            fprintf('failed.\n');
        end
    end

    % Query XM for connected sensors
    if num_MTs==0,
        disp('Xbus Master not found or no sensors found by Xbus Master...exiting.')
        delete(h); clear h; close(f_handle)
        return
    elseif (~isempty(jointIDs) && length(jointIDs)~=num_MTs)
        disp('Number of joint IDs is not equal to number of sensors!')
        delete(h); clear h; close(f_handle)
        return
    end
    
    % request the Sample Frequency (update rate) of the MTi or MTx
    SF = h.XM_GetXbusMasterSampleFrequency;
%     res.SampleFrequency=SF;
    
    mot = emptyMotion;
    mot.njoints = 31;
    
    for i=1:num_MTs,
        % Note: Creating Cell array of device IDs for use in Set functions
        % below
        res.MT_IDs{i,1} = DIDs((i*8 - 7):(i*8));
        if isempty(jointIDs)
            fprintf('Enter jointID of MT %s! (1...%i)',res.MT_IDs{i},mot.njoints);
            res.MT_jointIDs{i,1}=input(' ');
        else
            res.MT_jointIDs{i,1}=jointIDs(i);
        end
        mot.animated=[mot.animated ; res.MT_jointIDs{i}];
        h.XM_SetFilterSettings(char(res.MT_IDs(i)),...
            filterSettings_gain,filterSettings_corr, filterSettings_weight);
%         h.XM_SetDoAMD(char(MT_IDs(i)), 1);
    end
    
    mot.animated    = sort(mot.animated);
    mot.unanimated  = setxor(1:mot.njoints,mot.animated)';
    
    % request calibrated inertial and magnetic data
    h.XM_SetCalibratedOutput(1);
    DC=[];
    DO=[];

    % init figure plotting variables
    % set time scale zoom level
    zoom_levels = [12*SF,8*SF,4*SF]; % in seconds
    zoom_level  = zoom_levels(zoom_level_setting);
    OldFigureUserData   = [0 0 0]; 
    status      = 0; 
    last_t      = 0;
    % default vertical zoom
    YLims       = [-22 22; -1200 1200; -1.8 1.8; -1 1];
    ResetFigure =1; 
    first_time  =1;
    
    outputFilename = input('Enter output filename (Press Enter for default filename using timestamp) ','s');
         
    % create figure
    % NOTE, the releasing of MTObj is done in the Figure Close Request function
    % "mt_figure_close"
    [f_handle, p_handle] = xm_create_figure(OldFigureUserData(3), -1 ,h, YLims, SF,...
        zoom_level, OldFigureUserData, 1, ' ');
     
    % choose what data to ask from MTObj and store in figure UserData
    if strcmp(DisplayMode,'caldata')
        Channels = 10;
        OChannels = 4;
        Motion.OriRep = 'Quat';
        % set figure UserData to appropriate values (format:
        % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 0])
    elseif strcmp(DisplayMode,'quat')
        Channels = 4;
        OChannels = 4;
        Motion.OriRep = 'Quat';
        % request orientation data in quaternions
        h.XM_SetOutputMode(0);
        % set figure UserData to appropriate values (format:
        % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 5])
    elseif strcmp(DisplayMode,'matrix')
        Motion.OriRep = 'Matrix';
        Channels = 9;
        OChannels = 9;
        % request orientation data in DCM rotation matrix
        h.XM_SetOutputMode(2);
        % set figure UserData to appropriate values (format:
        % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 6])
    end
    

    % That's it!
    % MTObj is ready to start processing the data stream from the MTi or MTx
    h.XM_StartProcess; % start processing data
%     pause(15);

    % init data variable
    d               = zeros(1,Channels);
    last_d          = d;
    MT_BeingPlotted = 1;
    
    % start capturing with button press
    waitforbuttonpress;
    
    if ~isempty(outputFilename)
        [pathstr, name] = fileparts(outputFilename);
    else
        pathstr     = ['Session-' datestr(clock,'yyyy-mm-dd')];
        name        = ['Motion-' datestr(clock,'HH-MM-SS')];
    end
    res.outputFilename = fullfile(pathstr,name);
    
    % Video object initialization
    if videoCapture
        res.aviFilename     = [res.outputFilename '.avi'];
        aviobj              = avifile(res.aviFilename,'fps',25);
        disp(aviobj);
        vid                 = videoinput('winvideo',1);
        vid.LoggingMode     = 'disk&memory';
        vid.DiskLogger      = aviobj;
        vid.TriggerRepeat   = inf;
        start(vid);
    end

    % flush buffer
    XM_get_data_jt(h, 10, num_MTs);
    XM_get_data_jt(h, OChannels, num_MTs);

    while ishandle(f_handle) && ishandle(h), % check if all objects are alive

        if status ~= 0,
            last_d=d(end,:);
        end

        % retreive data from MTObj object
        [dC,statusC,NC]=XM_get_data_jt(h, 10, num_MTs);
        [dO,statusO,NO]=XM_get_data_jt(h, OChannels, num_MTs);
        if (Channels==10)
            [d,status,N]=deal(dC,statusC,NC);
        else
            [d,status,N]=deal(dO,statusO,NO);
        end
        if (statusC==1)
            DC=[DC;dC];
        end
        if (statusO==1)
            DO=[DO;dO];
        end
        
        % Now the data is available! The rest of the code is only to
        % display the data and to make it look nice and smooth on display....

        if (status==1), % default mode...
            
            d=d(:,(MT_BeingPlotted-1)*Channels+2:MT_BeingPlotted*Channels+1);

            % retrieve values from figure
            CurrentFigureUserData = get(f_handle,'UserData');

            if ResetFigure ==1, % check if figure should be reset
                last_t=0; % wrap plot around
                figureUserData = get(f_handle,'UserData');
                % call local function to (re)setup figure
                [f_handle, p_handle] = xm_create_figure(CurrentFigureUserData(3), f_handle,h, YLims, SF,...
                    zoom_level, figureUserData, MT_BeingPlotted, res.MT_IDs);
                ResetFigure = 0;
            end

            % create timebase
            t=(last_t:last_t+N)./SF;
            last_t=last_t+N;

            % check if to change MTx being plotted
            if CurrentFigureUserData(1)
                MT_BeingPlotted = mod(MT_BeingPlotted+1,num_MTs);
                if MT_BeingPlotted==0,
                    MT_BeingPlotted = num_MTs;
                end
                CurrentFigureUserData(1) = 0;% reset next MT toggle
                set(f_handle,'UserData', CurrentFigureUserData);
                ResetFigure =1; % make sure plot is reset
                first_time =1; % re-initialize zoom levels too
                % check if figures should be reset
            elseif any(CurrentFigureUserData ~= OldFigureUserData), % check if figure UserData changed by KeyPress
                ResetFigure =1; % make sure plot is reset
                first_time =1; % re-initialize zoom levels too
            elseif last_t>zoom_level || first_time==1
                ResetFigure =1; % make sure plot is reset
                first_time =0;
                YLims = mt_plot_data(d, last_d, t, CurrentFigureUserData, p_handle);
            else % other wise --> plot
                % plot the data using a local funtion
                YLims = mt_plot_data(d, last_d, t, CurrentFigureUserData, p_handle);
            end

            OldFigureUserData = CurrentFigureUserData;

        elseif status>1,
            % MTObj not correctly configured, stopping
            [str_out]=MT_return_error(status);
            disp(str_out);
            disp('MTObj not correctly configured, stopping.....');
            break
        end % if

    end % while
    
    if videoCapture
        stop(vid);
        fprintf('Writing frames to avi file... \n');
        fprintf('\t\t\t\t\t\t\t\t\t');
        count=0;
        while vid.FramesAvailable>vid.DiskLoggerFrameCount
            if vid.DiskLoggerFrameCount>count
                fprintf('\b\b\b\b\b\b\b\b\b%3i / %3i',vid.DiskLoggerFrameCount,vid.FramesAvailable);
                count=vid.DiskLoggerFrameCount;
            end
        end
        fprintf('\b\b\b\b\b\b\b\b\b%3i / %3i\n',vid.DiskLoggerFrameCount,vid.FramesAvailable);
        fprintf('...finished.\n');
        close(vid.DiskLogger);   
        delete(vid);
        clear vid;
    end
    
    frames=min(size(DC,1),size(DO,1));
    res.rawCalData=cell(num_MTs,1);
    res.rawOriData=cell(num_MTs,1);
    for i=1:num_MTs
        res.rawCalData{i,1}=DC(1:frames,(i-1)*10+2:i*10+1);
        res.rawOriData{i,1}=DO(1:frames,(i-1)*OChannels+2:i*OChannels+1);
    end
    
    mot.jointAccelerations=cell(mot.njoints,1);
    g=9.8112; % gravity in Römerstraße 164, Bonn (Germany) ;-)
    for i=1:num_MTs
        switch OChannels
%             case 3  % Euler angles
%                 fprintf('\n There''s an error in the calculation of the global accelerations using Euler angles!\n');
%                 rotQuat = euler2quat((res.rawOriData{i,1}*pi/180)','zxy');
            case 4  % Quaternions
                rotQuat = (res.rawOriData{i,1}');
            case 9  % Rotation matrices
                rotMats=zeros(3,3,frames);
                for j=1:frames
                    rotMats(:,:,j)=reshape(res.rawOriData{i,1}(j,:),[3,3]);
                end
                rotQuat = (matrix2quat(rotMats));
        end
        mot.jointAccelerations{res.MT_jointIDs{i},1} = ...
            quatrot(res.rawCalData{i,1}(:,1:3)',rotQuat)...
            - repmat([0;0;g],1,frames); % substracting acceleration due to gravity
                            
    %     filtering
        mot.jointAccelerations{res.MT_jointIDs{i}} = ...
            filterTimeline(mot.jointAccelerations{res.MT_jointIDs{i}},2,'bin');

        % switching the axes so that y is pointing up (right 
        % handed system)  
        mot.jointAccelerations{res.MT_jointIDs{i}} = ...
            mot.jointAccelerations{res.MT_jointIDs{i}}([2,3,1],:);
    end
    
%     res.TimeLine        = DC(1:frames,1)-DC(1,1);
%     res.LengthInSeconds = res.TimeLine(end);
%     res.frameTime       = 1/SF;
%     res.samplingRate    = SF;

    mot.samplingRate    = SF;
    mot.frameTime       = 1/SF;
    mot.nframes         = length(DC);
    mot.filename        = name;
    
    res.motion          = mot;
    
    if (~isempty(pathstr)&&~isdir(pathstr))
        mkdir(pathstr);
    end
    save (res.outputFilename,'res');

    % release MTObj is done on figure close...not here
    if ishandle(f_handle), % check to make sure figure is not already gone
        close(f_handle)
    end

catch % try catch for debugging
    % make sure MTObj is released even on error
    h.XM_StopProcess;
    delete(h);
    clear h;
    % display some information for tracing errors
    disp('Error was catched by try-catch.....MTobj released')
    crashInfo = lasterror; % retrieve last error message from MATLAB
    disp('Line:')
    crashInfo.stack.line
    disp('Name:')
    crashInfo.stack.name
    disp('File:')
    crashInfo.stack.file
    rethrow(lasterror)
end
% -------------------------------------------------------------------------
% end of function captureXsens(varargin);


%% -------------------------------------------------------------------------
% LOCAL FUNCTIONS
% -------------------------------------------------------------------------
function [f_handle, p_handle] = xm_create_figure(type, f_handle, h, YLims,SF, zoom_level, figureUserData, MT_BeingPlotted, MT_IDs)

% local function to create the figure for real time plotting of data.
% accepts plot type information for custom plots
%
% if figure does not yet exist enter -1 in figure_handle input

if ~ishandle(f_handle),
    % create figure
    f_handle = figure('Name','Real-time display and capturing of MTi or MTx data: Click to start capturing, press "q" to stop','NumberTitle','off');
end

fontSizeUsed = 12;
axisName = {'X' 'Y' 'Z'};
eulerName = {'Roll' 'Pitch' 'Yaw'};
quatName = {'img w q_0' 'x q_1' 'y q_2' 'z q_3'};

% init
p_handle = zeros(9); a_handle = zeros(9);
figure(f_handle); % raise figure

switch type
    case 0% calibrated inertial and magnetic data(default)
        for i=1:9,
            subplot(3,3,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(mod(i-1,3)+1,:)]);
            grid on;
        end
        tlh = title(a_handle(1),['Acceleration [m/s^2]']);   set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(7),'time [s]');  ylh = ylabel(a_handle(1),'X_S');
        tlh = title(a_handle(2),['Gyro [deg/s]']);           set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(8),'time [s]');  ylh = ylabel(a_handle(4),'Y_S');
        tlh = title(a_handle(3),['Magnetometer [a.u.]']);    set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(9),'time [s]');  ylh = ylabel(a_handle(7),'Z_S');

    case 1 %'acc' (only accelerometer)
        for i=1:3,
            subplot(3,1,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(i,:)]); grid on;
            ylh =  ylabel(a_handle(i),[axisName{i} '_S acceleration [m/s^2]']); set(ylh,'FontSize',fontSizeUsed-1);
        end
        tlh = title(a_handle(1),['Accelerometer data']); set(tlh,'FontSize',fontSizeUsed);
        xlh = xlabel('time [s]'); set(xlh,'FontSize',fontSizeUsed);

    case 2 % 'gyr' (only gyroscopes)
        for i=1:3,
            subplot(3,1,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(i,:)]); grid on;
            ylh =  ylabel(a_handle(i),[axisName(i) '_S angular rate [deg/s]']);  set(ylh,'FontSize',fontSizeUsed-1);
        end
        tlh = title(a_handle(1),['Rate gyroscope data']); set(tlh,'FontSize',fontSizeUsed);
        xlh = xlabel('time [s]'); set(xlh,'FontSize',fontSizeUsed);

    case 3 % 'mag' (only magnetometers)
        for i=1:3,
            subplot(3,1,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(i,:)]); grid on;
            ylh =  ylabel(a_handle(i),[axisName(i) '_S magnetometer [a.u.]']);  set(ylh,'FontSize',fontSizeUsed-1);
        end
        tlh = title(a_handle(1),['Magnetometer data']); set(tlh,'FontSize',fontSizeUsed);
        xlh = xlabel('time [s]'); set(xlh,'FontSize',fontSizeUsed);

    case 4 % Euler angles
        for i=1:3,
            subplot(3,1,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(i,:)]); grid on;
            ylh =  ylabel(a_handle(i),[eulerName(i) ' [deg]']);  set(ylh,'FontSize',fontSizeUsed-1);
        end
        tlh = title(a_handle(1),['Euler angle orientation data']); set(tlh,'FontSize',fontSizeUsed);
        xlh = xlabel('time [s]'); set(xlh,'FontSize',fontSizeUsed);

        if figureUserData(2)==0, % try to get nice scales on graphs
            set(a_handle(1),'ytick',[-180:45:180]); set(a_handle(2),'ytick',[-90:45:90]); set(a_handle(3),'ytick',[-180:45:180]);
        elseif figureUserData==1,
            set(a_handle(1),'ytick',[-180:2:180]); set(a_handle(2),'ytick',[-90:2:90]); set(a_handle(3),'ytick',[-180:2:180]);
        end

    case 5 % Quaternion
        for i=1:4,
            subplot(4,1,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(i,:)]); grid on;
            ylh =  ylabel(a_handle(i),quatName(i));  set(ylh,'FontSize',fontSizeUsed-1);
        end
        tlh = title(a_handle(1),['Quaternion orientation data q_G_S']); set(tlh,'FontSize',fontSizeUsed);
        xlh = xlabel('time [s]'); set(xlh,'FontSize',fontSizeUsed);

    case 6 % DCM rotation matrix
        subplot(1,1,1), p_handle(1)=surf(zeros(4,4),'EraseMode','none'); a_handle(1)  = gca;
        tlh = title(['Rotation Matrix Output R_G_S   -    MTi / MTx']); set(tlh,'FontSize',fontSizeUsed,'Color','white');
        axis ij;
        xlh = xlabel('cols'); ylh_1 = ylabel('rows');
        % set(f_handle,'Renderer','OpenGL');  % Use OpenGL renderer for smoother plotting
        set(f_handle,'Color','black','Colormap',colormap(hsv));
        view(2); shading flat;
        set(a_handle(1),'CLim',[-1 1]); cbh = colorbar('vert'); set(cbh,'YColor','white')
end

% add text about which MTx data is displayed from
% text will be displayed wrt last axis active...
vertPos = 1.25* min(get(gca,'Ylim'))- 0.25 * max(get(gca,'YLim'));
txtMT_DID = text(0,vertPos,['MTx number ' num2str(MT_BeingPlotted) ': MTx DID = ' char(MT_IDs(MT_BeingPlotted))]);
set(txtMT_DID,'FontSize',fontSizeUsed+1);

set(f_handle,'CloseRequestFcn',{@mt_figure_close,h,f_handle});
set(f_handle,'KeyPressFcn',{@mt_figure_keypress,h,f_handle});
set(f_handle,'UserData', figureUserData);
% -------------------------------------------------------------------------
% end of function


%% -------------------------------------------------------------------------
function mt_figure_keypress(obj, eventdata, h, f_handle)

% local function to handle KeyPress events on figure.
% Is used to (P)ause plot, (Z)oom in/out, (D)efault display,
% (A)ccelerometer only, rate (G)yro only, (M)agnetometer only
%
% envoked when a key is pressed when figure is in focus

in_key=lower(get(f_handle,'CurrentCharacter'));
tmp = get(f_handle,'UserData');

switch in_key
    case 'n' % view next connected sensor...
        pause(0.2)
        figure(f_handle);
        tmp = get(f_handle,'UserData');
        tmp(1) = 1;% indicate that next MT9 should be plotted
        set(f_handle,'UserData', tmp);
    case 'q'
        disp('Quitting demo XM_CaptureData_jt...')
        pause(0.2)
        figure(f_handle)
        close(f_handle)
    otherwise
        disp('Unknown command option....displaying help data')
        disp(' ')
        eval('help XM_CaptureData_jt')

end

if ishandle(f_handle) % needed to check if figure exists (using Q to quit)
    if tmp(3)>3,% If in Orientation output mode, IGNORE any change in PlotMode!!!
        tmp_new = get(f_handle,'UserData');
        set(f_handle,'UserData',[tmp_new(1:2) tmp(3)]);
    end

    % reset CurrentCharater to no value...
    set(f_handle,'CurrentCharacter',' ');
end
% -------------------------------------------------------------------------
% end of function



%% -------------------------------------------------------------------------
function YLims = mt_plot_data(d, last_d, t, CurrentFigureUserData, p_handle)

% local function to plot the data using "low-level" set fucntions for smooth plotting

switch CurrentFigureUserData(3) % check plot type
    case 0 %default

        if CurrentFigureUserData(2), % check if zoomed
            band = [0.8 40 0.1]; % define zoom range
            YLims = [min(d(1,1:3))-band(1) max(d(1,1:3))+band(1); min(d(1,4:6)./pi.*180)-band(2) max(d(1,4:6)./pi.*180)+band(2);...
                min(d(1,7:9))-band(3) max(d(1,7:9))+band(3)];
        else % default values of zoom (full range of MT9)
            YLims = [-22 22; -1200 1200; -1.8 1.8];
        end

        %     plot the data
        set(p_handle(1),'XData',t,'YData',[last_d(1,1) d(:,1)'],'Color','b','LineWidth',2)
        set(p_handle(4),'XData',t,'YData',[last_d(1,2) d(:,2)'],'Color','g','LineWidth',2)
        set(p_handle(7),'XData',t,'YData',[last_d(1,3) d(:,3)'],'Color','r','LineWidth',2)

        % convert the rate of turn data to deg/s instead of rad/s
        set(p_handle(2),'XData',t,'YData',([last_d(1,4) d(:,4)'])./pi.*180,'Color','b','LineWidth',2)
        set(p_handle(5),'XData',t,'YData',([last_d(1,5) d(:,5)'])./pi.*180,'Color','g','LineWidth',2)
        set(p_handle(8),'XData',t,'YData',([last_d(1,6) d(:,6)'])./pi.*180,'Color','r','LineWidth',2)

        set(p_handle(3),'XData',t,'YData',[last_d(1,7) d(:,7)'],'Color','b','LineWidth',2)
        set(p_handle(6),'XData',t,'YData',[last_d(1,8) d(:,8)'],'Color','g','LineWidth',2)
        set(p_handle(9),'XData',t,'YData',[last_d(1,9) d(:,9)'],'Color','r','LineWidth',2)

    case 1 % Only accelerometer

        if CurrentFigureUserData(2), % check if zoomed
            band = 0.8; % define zoom range (in m/s2)
            YLims = [min(d(:,1))-band max(d(:,1))+band; min(d(:,2))-band max(d(:,2))+band; ...
                min(d(:,3))-band max(d(:,3))+band];
        else % default values of zoom (full range of MT9)
            YLims = [-25 25; -25 25; -25 25];
        end

        %     plot the data
        set(p_handle(1),'XData',t,'YData',[last_d(1,1) d(:,1)'],'Color','b','LineWidth',2)
        set(p_handle(2),'XData',t,'YData',[last_d(1,2) d(:,2)'],'Color','g','LineWidth',2)
        set(p_handle(3),'XData',t,'YData',([last_d(1,3) d(:,3)']),'Color','r','LineWidth',2)

    case 2 % Only rate gyros

        if CurrentFigureUserData(2), % check if zoomed
            band = 40; % define zoom range (in deg/s)
            YLims = [min(d(:,4)./pi.*180)-band max(d(:,4)./pi.*180)+band;...
                min(d(:,5)./pi.*180)-band max(d(:,5)./pi.*180)+band; min(d(:,6)./pi.*180)-band max(d(:,6)./pi.*180)+band];
        else % default values of zoom (full range of MT9)
            YLims = [-1200 1200; -1200 1200; -1200 1200];
        end

        %     plot the data
        set(p_handle(1),'XData',t,'YData',([last_d(1,4) d(:,4)'])./pi.*180,'Color','b','LineWidth',2)
        set(p_handle(2),'XData',t,'YData',([last_d(1,5) d(:,5)'])./pi.*180,'Color','g','LineWidth',2)
        set(p_handle(3),'XData',t,'YData',([last_d(1,6) d(:,6)'])./pi.*180,'Color','r','LineWidth',2)

    case 3 % Only magnetometers

        if CurrentFigureUserData(2), % check if zoomed
            band = 0.1; % define zoom range (in a.u.)
            YLims = [min(d(:,7))-band max(d(:,7))+band; min(d(:,8))-band max(d(:,8))+band; min(d(:,9))-band max(d(:,9))+band];
        else % default values of zoom (full range of MT9)
            YLims = [-2.5 2.5; -2.5 2.5; -2.5 2.5];
        end

        %     plot the data
        set(p_handle(1),'XData',t,'YData',[last_d(1,7) d(:,7)'],'Color','b','LineWidth',2)
        set(p_handle(2),'XData',t,'YData',[last_d(1,8) d(:,8)'],'Color','g','LineWidth',2)
        set(p_handle(3),'XData',t,'YData',[last_d(1,9) d(:,9)'],'Color','r','LineWidth',2)

    case 4 % Euler angles

        if CurrentFigureUserData(2), % zoom UserData
            band = 6; % define zoom range (in degrees)
            YLims = [min(d(:,1))-band max(d(:,1))+band; min(d(:,2))-band max(d(:,2))+band; ...
                min(d(:,3))-band max(d(:,3))+band];
        else % default values of zoom (full range of Euler angles)
            YLims = [-180 180;-90 90;-180 180];
        end
        set(p_handle(1),'XData',t,'YData',[last_d(1,1) d(:,1)'],'Color','b','LineWidth',2)
        set(p_handle(2),'XData',t,'YData',[last_d(1,2) d(:,2)'],'Color','g','LineWidth',2)
        set(p_handle(3),'XData',t,'YData',[last_d(1,3) d(:,3)'],'Color','r','LineWidth',2)

    case 5 % Quaternions

        if CurrentFigureUserData(2), % zoom UserData
            band = 0.14; % define zoom range
            YLims = [min(d(1,1))-band max(d(1,1))+band; min(d(1,2))-band max(d(1,2))+band;...
                min(d(1,3))-band max(d(1,3))+band; min(d(1,4))-band max(d(1,4))+band]; % not so useful for quaternions...
        else % default values of zoom (full range of Euler angles)
            YLims = [-1 1; -1 1; -1 1; -1 1;];
        end
        set(p_handle(1),'XData',t,'YData',[last_d(1,1) d(:,1)'],'Color','k','LineWidth',2)
        set(p_handle(2),'XData',t,'YData',[last_d(1,2) d(:,2)'],'Color','b','LineWidth',2)
        set(p_handle(3),'XData',t,'YData',[last_d(1,3) d(:,3)'],'Color','g','LineWidth',2)
        set(p_handle(4),'XData',t,'YData',[last_d(1,4) d(:,4)'],'Color','r','LineWidth',2)

    case 6 % Matrix

        YLims = [0 4]; % not used
        % only display latest data available in DCM orientation matrix mode
        set(p_handle(1),'cdata',[d(end,1:3); d(end,4:6); d(end,7:9)]');

end % switch

% flush the graphics to screen
drawnow
% -------------------------------------------------------------------------
% end of function


%% -------------------------------------------------------------------------
function mt_figure_close(obj, eventdata, h, f_handle)

% local function to properly release MTObj when the user kills the figure window.

% release MTObj
XM_StopProcess(h)
delete(h);
clear h;

% kill figure window as requested
delete(f_handle)
% -------------------------------------------------------------------------
% end of function
