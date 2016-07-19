function aviobj=motionplayerProVideo(skel,mot, parameter,varargin)
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
%       parameter.padFramesBefore
%       parameter.padBeforeTye = 'image' | 'bg'
%       parameter.bgColor = [235, 242, 242];
%       parameter.padFramesAfter
%       parameter.padAfterTye = 'image' | 'bg'
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
     parameter.compression = 'none';
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
     parameter.motDownsampling = 1;
end
if isfield(parameter, 'cameraFcn') == 0
     parameter.cameraFcn = 'camera';
end

if isfield(parameter, 'padFramesBefore') == 0
     parameter.padFramesBefore = 0;
end
if isfield(parameter, 'padBeforeType') == 0
     parameter.padBeforeType = 'bg';
end
if isfield(parameter, 'bgColor') == 0
     parameter.bgColor = [235, 242, 242];
end
if isfield(parameter, 'padFramesAfter') == 0
     parameter.padFramesAfter = 0;
end
if isfield(parameter, 'padAfterType') == 0
     parameter.padAfterType = 'bg';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
motionplayerPro('skel', skel, 'mot', mot);%,'color',{[0 0.8 0] [0.8 0 0]});
% light('Position',[0 100 0],'Style','infinite');
% motionplayer('skel', skel, 'mot'
% now delete the control panel
delete(findobj(gcf, 'type', 'uipanel'));

% set figure size and position
set(gcf, 'position', [parameter.position(:) parameter.size(:)]);

% set camera parameters
if ~isempty(parameter.cameraFcn)
    feval(str2func(parameter.cameraFcn), gca);
end

maxframes=0;
for motion=1:size(mot,1)
    if mot{motion}.nframes>maxframes
        maxframes=mot{motion}.nframes;
    end
end

frames = 1:parameter.motDownsampling:maxframes;
fprintf('\n');
disp('*************************************************************');
disp('Starting onscreen rendering. Do not move the windows or hover');
disp('over the figure with the mouse because it will be seen in the avi.');
disp('*************************************************************');
fprintf('\n');

% open avi
aviobj = avifile(parameter.filename, ...
    'compression',  parameter.compression, ...
    'quality',parameter.quality,...
    'fps',parameter.fps);
%use try-catch to close the avi if anything bad happens
% try 
    
    % add padding frames before the animation
    if parameter.padFramesBefore > 0
        switch parameter.padBeforeType
            case 'bg'
                image = uint8(ones(parameter.size(2), parameter.size(1), 3));
                image(:,:,1) = image(:,:,1)*parameter.bgColor(1);
                image(:,:,2) = image(:,:,2)*parameter.bgColor(2);
                image(:,:,3) = image(:,:,3)*parameter.bgColor(3);
                frame = im2frame(image);
            case 'image'
                setFramePro(1);
                frame = getframe(gcf);
        end
        for f = 1: parameter.padFramesBefore 
            aviobj = addframe(aviobj,frame);            
        end
    end
   
    
    strlen = -2;
    numFrames = length(frames);
    for k = 1:numFrames
        setFramePro(frames(k));

        frame = getframe(gcf);
        aviobj = addframe(aviobj,frame);
        
        s = ['Frame ' num2str(k) ' of ' num2str(numFrames)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);


    end
    
    % add padding frames after the animation    
    
    if parameter.padFramesAfter > 0
        switch parameter.padAfterType
            case 'bg'
                image = uint8(ones(parameter.size(2), parameter.size(1), 3));
                image(:,:,1) = image(:,:,1)*parameter.bgColor(1);
                image(:,:,2) = image(:,:,2)*parameter.bgColor(2);
                image(:,:,3) = image(:,:,3)*parameter.bgColor(3);
                frame = im2frame(image);
            case 'image'
                setFrame(frames(end));
                frame = getframe(gcf);
        end
        for f = 1: parameter.padFramesAfter 
            aviobj = addframe(aviobj,frame);            
        end
    end    
    
% catch ME
%     if strcmp(aviobj.CurrentState, 'Open') == 1    
%         aviobj=close(aviobj);
%     end
%     ME.stack
%     warning('Avi creation did not complete.');
% end
if strcmp(aviobj.CurrentState, 'Open') == 1    
    aviobj=close(aviobj);
end

    