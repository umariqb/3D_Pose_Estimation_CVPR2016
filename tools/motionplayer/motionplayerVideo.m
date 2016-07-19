function aviobj=motionplayerVideo(skel,mot, parameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: motionplayerVideo
% Version: 1
% Date: 20.09.2008
% Programmer: Andreas Baak
%
% Description: Plays the motion using the motionplayer tool and records
%              a video of the scene at the same time.
%
% Input:  
%       skel: 
%       mot:       
%       parameter.filename = 'default.avi'
%       parameter.fps = 30 % fps of the avi
%       parameter.compression = 'Indeo5'; %compression of the avi. 
%               Set to 'none' for uncompressed streams.
%       parameter.quality = 100 % percentage quality value for the
%           compression
%       parameter.size = [800, 600]; % width and height of the avi frames
%           in pixels
%       parameter.position = [100,100] % position of the figure on the
%           screen in pixels [1,1] == bottom left of the screen.
%       parameter.motDownsampling = 4 % Downsample mot by this value. Typical
%           value for 120 Hz mots is 4. Then the mot is in sync with 30 fps avi.
%       parameter.cameraFcn = '' % Set this to a nonempty string if you 
%           want to specify a function that sets the camera parameter for
%           the current axis.
%         
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<2
   error('Please specify input data');
end

if nargin<3
   parameter=[]; 
end

if isfield(parameter, 'filename') == 0
     parameter.filename = 'default.avi';
end
if isfield(parameter, 'fps') == 0
     parameter.fps = 30;
end
if isfield(parameter, 'compression') == 0
     parameter.compression = 'Indeo5';
end
if isfield(parameter, 'quality') == 0
     parameter.quality = 100;
end

if isfield(parameter, 'position') == 0
     parameter.position = [100,100];
end
if isfield(parameter, 'size') == 0
     parameter.size = [800, 600];
end



if isfield(parameter, 'motDownsampling') == 0
     parameter.motDownsampling = 4;
end
if isfield(parameter, 'cameraFcn') == 0
     parameter.cameraFcn = '';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
motionplayer('skel', {skel}, 'mot', {mot});
% now delete the control panel
delete(findobj(gcf, 'type', 'uipanel'));

% set figure size and position
set(gcf, 'position', [parameter.position(:) parameter.size(:)]);

% set camera parameters
if ~isempty(parameter.cameraFcn)
    feval(str2func(parameter.cameraFcn), gca);
end

frames = 1:parameter.motDownsampling:mot.nframes;
fprintf('\n');
disp('*************************************************************');
disp('Starting onscreen rendering. Do not move the windows or hover');
disp('over the figure with the mouse because it will be seen in the avi.');
disp('*************************************************************');
fprintf('\n');

% open avi
aviobj = avifile(parameter.filename, ...
    'quality',parameter.quality,...
    'fps',parameter.fps);
%use try-catch to close the avi if anything bad happens
try 
    strlen = -2;
    numFrames = length(frames);
    for k = 1:numFrames
        setFrame(frames(k));

        frame = getframe(gcf);
        aviobj = addframe(aviobj,frame);
        
        s = ['Frame ' num2str(k) ' of ' num2str(numFrames)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);


    end
catch ME
    if strcmp(aviobj.CurrentState, 'Open') == 1    
        aviobj=close(aviobj);
    end
    ME.stack
    warning('Avi creation did not complete.');
end
if strcmp(aviobj.CurrentState, 'Open') == 1    
    aviobj=close(aviobj);
end

    