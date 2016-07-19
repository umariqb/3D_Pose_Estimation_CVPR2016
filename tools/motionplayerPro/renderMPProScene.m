function renderMPProScene(varargin)

global SCENE;

set(SCENE.handles.control_Panel,'Visible','off')

fprintf('\n');
disp('*************************************************************');
disp('Starting onscreen rendering in 3 secs. Do not move the figure or');
disp('hover over it with the mouse because it will be seen in the avi.');
disp('Note that in case of problems forcing Matlab to use software');
disp('rendering might solve the problem. Close the motionplayer window,');
disp('type "opengl software" and try again.');
disp('*************************************************************');
fprintf('\n');

pause(3);

if strcmp(SCENE.rendering.fps,'full')
    fps = SCENE.samplingRate;
    frames2render = 1:SCENE.nframes;
else
    fps = SCENE.rendering.fps;
    endframe = SCENE.nframes;
    frames2render = round(1:SCENE.samplingRate/fps:endframe);
    
%     frames2render = round(1:SCENE.samplingRate/fps:5750);
    % Note: avi files are limited to 4gb which seems to be about 2900 frames of uncompressed data!
end

% if numel(frames2render)>1000
%     frames2render = frames2render(1001:end);
% end

if strcmp(SCENE.rendering.filename,'timestamp')
    filename = ['MPPro-' datestr(clock,'yyyymmdd-HHMMSS') '.avi'];
else
    filename = SCENE.rendering.filename;
end

% try
    aviobj = avifile(filename, ...
    'compression',  SCENE.rendering.compression, ...
    'quality',      SCENE.rendering.quality,...
    'fps',          fps);

    % if additional figure is rendered set it to same width
    if isfield(SCENE,'addFig');
        
        mpposdata  = get(SCENE.handles.fig,'position');
        
        ratio = 16/5;
        mpposdata(4) = round(mpposdata(3)/ratio);
        set(SCENE.handles.fig,'position',mpposdata);
        
        figposdata = get(SCENE.addFig.fig,'position');
        
        ratio = 16/4;
        fignewpos = figposdata;
        fignewpos(3) = mpposdata(3);
        fignewpos(4) = round(mpposdata(3)/ratio);
        set(SCENE.addFig.fig,'position',fignewpos);
%         for i=1:numel(SCENE.addFig.axes)
%         set(SCENE.addFig.axes(i),'ylim',[0 100]);
%         end
    end
    
    fprintf('Rendering frame ');
    output = '';
    for k = 1:numel(frames2render)
        setFramePro(frames2render(k));

        frame = getframe(SCENE.handles.fig);
        
        if isfield(SCENE,'addFig')
            figure(SCENE.addFig.fig);
            figframe = getframe(SCENE.addFig.fig);
            figure(SCENE.handles.fig);
            frame.cdata = cat(1,frame.cdata,figframe.cdata);
        end
        
        
        aviobj = addframe(aviobj,frame);

        fprintf(repmat('\b',1,size(output,2)));
        output = sprintf('%i / %i',k,numel(frames2render));
        fprintf('%s',output);
        
    end
    fprintf('\n');
% catch ME
%     fprintf('\nVideo creation failed.\n%s\n',ME.message);
% end

fprintf('\nVideo file created: %s\n',filename);

if strcmp(aviobj.CurrentState, 'Open')
    aviobj = close(aviobj);
end 

set(SCENE.handles.control_Panel,'Visible','on')