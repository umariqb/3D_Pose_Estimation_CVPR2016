function fig = MPP_GUI(varargin)

global SCENE;

% figure and camera settings ----------------------------------------------

fig = figure('Visible','on',...
    'Name','MotionPlayerPro',...
    'NumberTitle','off',...
    'Position',[SCENE.position,SCENE.size],...
    'Resize', 'on', ...
    'Color', [0 0 0 ], ...%[.92 .95 .95],...
    'Interruptible','on',...
    'WindowScrollWheelFcn',@windowScrollWheelFcn,...
    'KeyPressFcn',@keyPressFunction,...
    'KeyReleaseFcn',@keyReleaseFunction,...
    'Renderer','OpenGl');
%     'WindowButtonDownFcn',@mouseButtonDownFunction,...
%     'WindowButtonUpFcn',@mouseButtonUpFunction,...

SCENE.handles.light = light('Position',SCENE.lightPosition,'Style','infinite');
set(SCENE.handles.light,'Visible',SCENE.status.light);

SCENE.keyEvents.shiftKeyDown    = false;
SCENE.keyEvents.altKeyDown      = false;

cameratoolbar(fig, 'Show');
cameratoolbar(fig, 'SetCoordSys',SCENE.status.mainAxis);

axis equal;
axis off;

hold all;

function keyPressFunction(src,evnt)
        switch(evnt.Key)
            case 'leftarrow'
                curFrame = max(SCENE.status.curFrame - 10,1);
                setFramePro(curFrame);
                drawnow();
            case 'downarrow'
                curFrame = max(SCENE.status.curFrame - 100,1);
                setFramePro(curFrame);
                drawnow();
            case 'rightarrow'
                curFrame = min(SCENE.status.curFrame + 10,SCENE.nframes);
                setFramePro(curFrame);
                drawnow();
            case 'uparrow'
                curFrame = min(SCENE.status.curFrame + 100,SCENE.nframes);
                setFramePro(curFrame);
                drawnow();
            case 'shift'
                if(~SCENE.keyEvents.shiftKeyDown)
                    SCENE.keyEvents.shiftKeyDown = true;
                    cameratoolbar(SCENE.handles.fig, 'SetCoordSys',SCENE.status.mainAxis);
                    cameratoolbar(SCENE.handles.fig, 'SetMode','orbit');
%                     set(cam_Status_Label,'String','orbit');
                end
            case 'alt'
                if(~SCENE.keyEvents.altKeyDown)
                    SCENE.keyEvents.altKeyDown = true;
                    cameratoolbar(SCENE.handles.fig, 'SetCoordSys',SCENE.status.mainAxis);
                    cameratoolbar(SCENE.handles.fig, 'SetMode','pan');
%                     set(cam_Status_Label,'String','pan');
                end
            case 'space'
                if(SCENE.status.running)
                    pauseFunction;
                else
                    playFunction;
                end
            otherwise
                disp('unknown key');
        end
    end

    function keyReleaseFunction(src,evnt)
        switch(evnt.Key)
            case 'shift'
                SCENE.keyEvents.shiftKeyDown = false;
                cameratoolbar(SCENE.handles.fig, 'SetCoordSys','none');
                cameratoolbar(SCENE.handles.fig, 'SetMode','nomode');
            case 'alt'
                SCENE.keyEvents.altKeyDown = false;
                cameratoolbar(SCENE.handles.fig, 'SetCoordSys','none');
                cameratoolbar(SCENE.handles.fig, 'SetMode','nomode');
        end
    end

    function windowScrollWheelFcn(src, evnt)
        f = .05;
        if(evnt.VerticalScrollCount < 0)
            zoom(1+f);
        else
            zoom(1-f);
        end
    end

end