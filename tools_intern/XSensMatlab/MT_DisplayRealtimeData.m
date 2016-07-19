function MT_DisplayRealtimeData(varargin)

%% MT_DisplayRealtimeData(varargin);
%
% Real-time display of calibrated data or 3D orientation data from an MTi
% or MTx
%
% varargin: Input arguments
% 1. COM-port [integer] to which MT is connected (default = 1 , i.e. COM1)
% 2. Display mode [string], choose to view:
%                   'caldata'          Calibrated inertial and magnetic data (default)
%                   'euler'            Orientation output in Euler-angles (see Tech Doc for definition)
%                   'quat'             Orientation output in Quaternions
%                   'matrix'           Orientation output in rotation Matrix format
% 3. zoom-level, [1=12 s chart, 2=8 s chart (default), 3=4 s chart]
% 4. update rate, [1=slow, 2=medium (default), 3=fast]
%
% example function call:
%   "MT_DisplayRealtimeData(1,'euler',2,3)"
%
% Press key on keyboard while running:
%
% Calibrated Inertial and magnetic data MODE:
% "Q" = Quit
% "P" = Pause/Start real-time plot
% "Z" = Toggle Zoom in/out
% "A" = View only accelerometer data
% "G" = View only rate gyro data
% "M" = View only magnetometer data
% "D" = View all MTi / MTx data (default)
%
% Orientation data output MODE:
% "Q" = Quit
% "P" = Pause/Start real-time plot
% "R" = Reset reference orientation (refer to Tech Doc for details)
% "Z" = Zoom in/out (not applicable for Matrix output mode)
% (it is not possible to switch orientation output mode during run-time)
%
% Xsens Technologies B.V., 2002-2007
% v.2.8.4
% tested to be compatible with MATLAB 2006b.

% The display code in this demo code has been changed due to a bug in MATLAB 7.x
% please refer to:
% http://www.mathworks.com/support/bugreports/details.html?rp=207276

% Check to see if number of input arguments is correct
if nargin>4,
    error('too many input arguments')
end

% set default values if needed
defaultValues={1,'caldata',2,1.0,1,1.0};
nonemptyIdx=~cellfun('isempty',varargin);
defaultValues(nonemptyIdx)=varargin(nonemptyIdx);
[COMport,DisplayMode,zoom_level_setting,filterSettings_gain,filterSettings_corr,filterSettings_weight]...
    =deal(defaultValues{:});

% set up MTObj
h=actxserver('MotionTracker.FilterComponent');

try
    % use try-catch to avoid the need to shutdown MATLAB if m-function fails (e.g. during debugging)
    % This is needed because MATLAB does not properly release COM-objects when
    % the m-function fails/crasehes and the object is not explicitly released with "delete(h)"

    % call MT_SetCOMPort is required, unless using COM 1
    h.MT_SetCOMPort(COMport);

    % request the Sample Frequency (update rate) of the MTi or MTx
    SF = h.MT_GetMotionTrackerSampleFrequency;

    % call MT_SetFilterSettings is optional
    h.MT_SetFilterSettings(filterSettings_gain,filterSettings_corr,filterSettings_weight);

    % init figure plotting variables
    % set time scale zoom level
    zoom_levels=[12*SF,8*SF,4*SF]; % in seconds
    zoom_level=zoom_levels(zoom_level_setting);
    OldFigureUserData = [0 0 0]; status = 0; last_t=0;
    % default vertical zoom
    YLims = [-22 22; -1200 1200; -1.8 1.8; -1 1];
    ResetFigure =1; first_time=1;
    % create figure
    % NOTE, the releasing of MTObj is done in the Figure Close Request function
    % "mt_figure_close"
    [f_handle, p_handle] = mt_create_figure(OldFigureUserData(3), -1 ,h, YLims, SF,...
        zoom_level, OldFigureUserData);

    % choose what data to ask from MTObj
    if strcmp(DisplayMode,'caldata')
        Channels = 10;
        % request calibrated inertial and magnetic data
        h.MT_SetCalibratedOutput(1);
        % set figure UserData to appropriate values (format:
        % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 0]) 
    elseif strcmp(DisplayMode,'euler')
        Channels = 3;
        % request orientation data in Euler-angles
        h.MT_SetOutputMode(1);
         % set figure UserData to appropriate values (format:
         % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 4])
    elseif strcmp(DisplayMode,'quat')
        Channels = 4;
        % request orientation data in quaternions
        h.MT_SetOutputMode(0);
         % set figure UserData to appropriate values (format:
         % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 5])
    elseif strcmp(DisplayMode,'matrix')
        Channels = 9;
        % request orientation data in DCM rotation matrix
        h.MT_SetOutputMode(2);
        % set figure UserData to appropriate values (format:
        % [MT_being_plotted, Zoom, PlotType])
        set(f_handle,'UserData', [0 0 6]) 
    else
        disp('unkown mode....stopping, check variable "Channels"!!')
        % clean up, release MTObj
        delete(h);
        clear h;
    end

    % That's it!
    % MTObj is ready to start processing the data stream from the MTi or MTx
    h.MT_StartProcess; % start processing data

    % init data variable
    d=zeros(1,Channels);
    last_d = d;
    while ishandle(f_handle) && ishandle(h), % check if all objects are alive

        if status ~= 0,
            last_d=d(end,:);
        end

        % retreive data from MTObj object
        [d,status,N]=MT_get_data(h, Channels);
        % Now the data is available! The rest of the code is only to
        % display the data and to make it look nice and smooth on display....

        if status==1, % default mode...

            % retrieve values from figure
            CurrentFigureUserData = get(f_handle,'UserData'); 

            if ResetFigure ==1, % check if figure should be reset
                last_t=0; % wrap plot around
                figureUserData = get(f_handle,'UserData');
                % call local function to (re)setup figure
                [f_handle, p_handle] = mt_create_figure(CurrentFigureUserData(3), f_handle,h, YLims, SF, zoom_level, figureUserData);
                ResetFigure = 0;
            end

            % create timebase
            t=[last_t:last_t+N]./SF;
            last_t=last_t+N;
            
            % check if figures should be reset
            if any(CurrentFigureUserData ~= OldFigureUserData), % check if figure UserData changed by KeyPress
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

    % release MTObj is done on figure close...not here
    if ishandle(f_handle), % check to make sure figure is not already gone
        close(f_handle)
    end

catch % try catch for debugging
    % make sure MTObj is released even on error
    h.MT_StopProcess;
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
% end of function MT_DisplayRealtimeData(varargin);





%% -------------------------------------------------------------------------
% LOCAL FUNCTIONS
% -------------------------------------------------------------------------
function [f_handle, p_handle] = mt_create_figure(type, f_handle, h, YLims,SF, zoom_level, figureUserData)

% local function to create the figure for real time plotting of data.
% accepts plot type information for custom plots
%
% if figure does not yet exist enter -1 in figure_handle input

if ~ishandle(f_handle),
    % create figure
    f_handle = figure('Name','Real-time display of MTi or MTx data','NumberTitle','off');
end

fontSizeUsed = 12;
axisName = {'X' 'Y' 'Z'};
eulerName = {'Roll' 'Pitch' 'Yaw'};
quatName = {'img w q_0' 'x q_1' 'y q_2' 'z q_3'};

% init
p_handle = zeros(9); a_handle = zeros(9);

switch type
    case 0% calibrated inertial and magnetic data(default)
        for i=1:9,
            subplot(3,3,i), p_handle(i)=plot(0,0,'EraseMode','none');a_handle(i) = gca; axis(a_handle(i),[0 (zoom_level+1)./SF YLims(mod(i-1,3)+1,:)]);
            grid on;
        end
        tlh = title(a_handle(1),['Acceleration [m/s^2] (press A)']);   set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(7),'time [s]');  ylh = ylabel(a_handle(1),'X_S');
        tlh = title(a_handle(2),['Gyro [deg/s] (press G)']);           set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(8),'time [s]');  ylh = ylabel(a_handle(4),'Y_S');
        tlh = title(a_handle(3),['Magnetometer [a.u.] (press M)']);    set(tlh,'FontSize',fontSizeUsed);   xlh = xlabel(a_handle(9),'time [s]');  ylh = ylabel(a_handle(7),'Z_S');

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
        p_handle(1)=surf(zeros(4,4),'EraseMode','none'); a_handle(1)  = gca;
        tlh = title(['Rotation Matrix Output R_G_S   -    MTi / MTx']); set(tlh,'FontSize',fontSizeUsed,'Color','white');
        axis ij;
        xlh = xlabel('cols'); ylh_1 = ylabel('rows');
        % set(f_handle,'Renderer','OpenGL');  % Use OpenGL renderer for smoother plotting
        set(f_handle,'Color','black','Colormap',colormap(hsv));
        view(2); shading flat;
        set(a_handle(1),'CLim',[-1 1]); cbh = colorbar('vert'); set(cbh,'YColor','white')
end

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
    case 'p' % pause to view graph
        disp('Paused, press any key to continue...')
        pause(0.2);% introduce a slight break, because otherwise 1 keystroke is recorded as multiple
        figure(f_handle);% raise figure to foreground
        pause; % wait for next key stroke

    case 'z' % toggle zoom mode
        pause(0.2)
        figure(f_handle)
        if tmp(2) == 0, % check zoom level
            set(f_handle,'UserData',[tmp(1) 1 tmp(3)]); % toggle to next zoom mode
        else
            set(f_handle,'UserData',[tmp(1) 0 tmp(3)]); % toggle to default zoom mode
        end

    case 'r' % reset orientation
        disp('Resetting heading orientation (boresight)...')
        pause(0.2);% introduce a slight break, because otherwise 1 keystroke is recorded as multiple
        figure(f_handle);% raise figure to foreground
        MT_ResetOrientation(h,0,0); % default reset type 0 = heading, do not save to MTS = 0 (second parameter)

    case 'a'
        disp('Switching to display only 3D accelerometer data stream...')
        pause(0.2)
        figure(f_handle)
        set(f_handle,'UserData',[tmp(1:2) 1]); % set to accelerometer mode

    case 'g'
        disp('Switching to display only 3D rate gyroscope data stream...')
        pause(0.2)
        figure(f_handle)
        set(f_handle,'UserData',[tmp(1:2) 2]); % set to gyro mode

    case 'm'
        disp('Switching to display only 3D magnetometer data stream...')
        pause(0.2)
        figure(f_handle)
        set(f_handle,'UserData',[tmp(1:2) 3]); % set to mag mode

    case 'd'
        disp('Switching the default display mode, all 9 data streams...')
        pause(0.2)
        figure(f_handle)
        set(f_handle,'UserData',[tmp(1:2) 0]); % set to default mode 

    case 'q'
        disp('Quitting demo MT_DisplayRealtimeData...')
        pause(0.2)
        figure(f_handle)
        close(f_handle)

    otherwise
        disp('Unknown command option....displaying help data')
        disp(' ')
        eval('help MT_DisplayRealtimeData')

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
            band = [0.8 50 0.1]; % define zoom range
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
            band = 50; % define zoom range (in deg/s)
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
MT_StopProcess(h)
delete(h);
clear h;

% kill figure window as requested
delete(f_handle)
% -------------------------------------------------------------------------
% end of function

