function fig = motionplayerProGUI(varargin)

global SCENE;

% help --------------------------------------------------------------------
helpDlg = {'Key-Bindings:',...
    '------------------------------------------------------',...
    '<space>:','       play/pause',...
    '<leftarrow>:','       move motion back 10 frames',...
    '<downarrow>:','       move motion back 100 frames',...
    '<rightarrow>:','       move motion forward 10 frames',...
    '<uparrow>:','       move motion forward 100 frames',...
    '<shift>+<mouse>:','       orbit rotate scene',...
    '<alt>+<mouse>:','       pan scene',...
    '<mousewheel>:','       zoom scene'};

% figure and camera settings ----------------------------------------------

fig = figure('Visible','on',...
    'Name','MotionPlayerPro',...
    'NumberTitle','off',...
    'Position',[SCENE.position,SCENE.size],...
    'Resize', 'on', ...
    'Color', [1 1 1], ...%[.92 .95 .95],...
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
% axis vis3d;
axis off;

renewAxisDimensions(SCENE.boundingBox);

% initializing figure with first frame(s) ---------------------------------
for j=1:SCENE.nmots
    
    if SCENE.nmots>1 % the interpolate skeleton colors
        c = (j-1)/(SCENE.nmots-1);
        interpolated_color = ...
               c     * SCENE.colors.multipleSkels_FaceVertexData_end...
             + (1-c) * SCENE.colors.multipleSkels_FaceVertexData_start;
    end
    
    nrOfNodes = size(SCENE.mots{j}.vertices{1},1)/3;
    
    for i=1:size(SCENE.mots{j}.vertices,1)-1
        
        v = reshape(SCENE.mots{j}.vertices{i+1}(:,1),3,nrOfNodes)';
        f = SCENE.mots{j}.faces;
        
        if SCENE.nmots==1
            SCENE.mots{j}.joint_handles(i) = ...
            patch('Vertices',v,'Faces',f,...
                  'FaceVertexCData',SCENE.colors.singleSkel_FaceVertexData,...
                  'FaceColor',SCENE.colors.singleSkel_FaceColor,...
                  'FaceAlpha',SCENE.colors.singelSkel_FaceAlpha, ...
                  'EdgeColor',SCENE.colors.singleSkel_EdgeColor);
        else
            SCENE.mots{j}.joint_handles(i) = ...
            patch('Vertices',v,'Faces',f,...
                 'FaceColor',hsv2rgb(interpolated_color),...
                  'FaceAlpha',SCENE.colors.multipleSkels_FaceAlpha, ...
                  'EdgeColor',SCENE.colors.multipleSkels_EdgeColor);
        end 
    end 
    SCENE.mots{j}.jointID_handles = -ones(SCENE.mots{j}.njoints,1);
end
hold all;

% % for j=1:SCENE.npoints
% %     if SCENE.npoints>1
% %         c = (j-1)/(SCENE.npoints-1);
% %     else
% %         c = 0;
% %     end
% %     color = ...
% %            c     * SCENE.colors.points_end...
% %          + (1-c) * SCENE.colors.points_start;
% %      
% %     i = mod(j,numel(SCENE.pointsSpec));
% %     if i==0, i=numel(SCENE.pointsSpec); end        
% %     SCENE.handles.points(j) = plot3(SCENE.points{j}(1:3:end,1),...
% %                                     SCENE.points{j}(2:3:end,1),...
% %                                     SCENE.points{j}(3:3:end,1),...
% %                                     SCENE.pointsSpec{i},'color',hsv2rgb(color));
% % end

if ~isempty(SCENE.objects)
    objects = fieldnames(SCENE.objects);
    
    nrOfDiffObjects = numel(objects);
    
    for p=1:nrOfDiffObjects
        for k=1:SCENE.objects.(objects{p}).counter
            color = SCENE.objects.(objects{p}).color{k};
            switch objects{p}
                case 'tetra'
                    coords  = [1 -1 -1 1;1 -1 1 -1;-1 -1 1 1];
                    f       = [1 2 3;1 2 4;1 3 4;2 3 4];
                        
                    nrOfObj = size(SCENE.objects.tetra.procdata{k},1);
                    if ~isempty(SCENE.objects.tetra.alpha{k})
                        alphaValues = SCENE.objects.tetra.alpha{k}(:,1);
                    else
                        alphaValues = ones(nrOfObj,1);
                    end
                    SCENE.handles.tetra{k}=zeros(nrOfObj,1);
                    for n=1:nrOfObj 
                        v = reshape(SCENE.objects.tetra.procdata{k}{n}(:,1),3,size(coords,2));
                        SCENE.handles.tetra{k}(n) = patch('Vertices',v','Faces',f,...
                                     'FaceColor',color,...
                                     'FaceAlpha',alphaValues(n), ...
                                     'EdgeColor','none');
                    end
                case {'dot','cross','circle'}
                    switch objects{p}
                        case 'dot',     lineSpec = '.';
                        case 'cross',   lineSpec = 'x';
                        case 'circle',  lineSpec = 'o';
                        otherwise
                            error('Unknown obj type');
                    end

                    SCENE.handles.(objects{p}){k} = plot3(SCENE.objects.(objects{p}).procdata{k}(1:3:end,1),...
                                                 SCENE.objects.(objects{p}).procdata{k}(2:3:end,1),...
                                                 SCENE.objects.(objects{p}).procdata{k}(3:3:end,1),...
                                                 lineSpec,'color',color);
                case {'line'}
                    nrOfLines = size(SCENE.objects.line.procdata{k},1);
                    nrOfJoints = size(SCENE.objects.line.procdata{k}{1},1)/3;
                    n=0;
                    color = rgb(SCENE.objects.line.color{k});
                    for n1=1:nrOfLines
                        for n2=1:nrOfJoints
                            n=n+1;
                            if ~isempty(SCENE.objects.line.alpha{k})
                                w = SCENE.objects.line.alpha{k}(n1,1);
                                color = w * color + (1-w) * [1 1 1];
                            end
                            SCENE.handles.line{k}(n) = plot3(SCENE.objects.line.procdata{k}{n1,1}(3*n2-2,:),...
                                                     SCENE.objects.(objects{p}).procdata{k}{n1,1}(3*n2-1,:),...
                                                     SCENE.objects.(objects{p}).procdata{k}{n1,1}(3*n2,:),...
                                                     '-','color',color);
                        end
                    end
            end
        end
    end
    
end

if SCENE.status.groundPlane_drawn
    computeGroundPlane(SCENE.boundingBox);
end

hold off;

% if SCENE.nmots>1 
%     spreadFunction();
% end

%% control panel-----------------------------------------------------------

SCENE.handles.control_Panel = uipanel(...
    'Parent',fig,...
    'Units','pixels',...
    'Position',[2 2 799 110],...
    'BackgroundColor',[.97 .97 .97]);

SCENE.handles.goto_First_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.goto_First,...'String','|<',...
    'Units','pixels',...
    'Position',[2 80 27 20],...
    'TooltipString','go to first frame',...
    'BackgroundColor',SCENE.colors.buttons_group1, ...
    'CallBack',@gotoFirstFunction);

SCENE.handles.play_reverse_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.play_reverse,...'String','<|',...
    'Units','pixels',...
    'Position',[30 80 27 20],...
    'TooltipString','play backwards',...
    'BackgroundColor',SCENE.colors.buttons_group1, ...
    'CallBack',@playReverseFunction);

SCENE.handles.pause_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.pause,...'String','||',...
    'Units','pixels',...
    'Position',[58 80 27 20],...
    'TooltipString','pause',...
    'BackgroundColor',SCENE.colors.buttons_group1, ...
    'CallBack',@pauseFunction);

SCENE.handles.play_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.play,...'String','|>',...
    'Units','pixels',...
    'Position',[86 80 27 20],...
    'TooltipString','play',...
    'BackgroundColor',SCENE.colors.buttons_group1, ...
    'CallBack',@playFunction);

SCENE.handles.goto_Last_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.goto_Last,...'String','>|',...
    'Units','pixels',...
    'Position',[114 80 27 20],...
    'TooltipString','go to last frame',...
    'BackgroundColor',SCENE.colors.buttons_group1, ...
    'CallBack',@gotoLastFunction);

SCENE.handles.slower_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.slower,...'String','<<',...
    'Units','pixels',...
    'Position',[148 80 27 20],...
    'TooltipString','slower',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@slowerFunction);

SCENE.handles.loop_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.unlooped,...'String','|--|',...
    'Units','pixels',...
    'Position',[176 80 27 20],...
    'TooltipString','loop',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@loopFunction);

SCENE.handles.faster_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.faster,...'String','>>',...
    'Units','pixels',...
    'Position',[204 80 27 20],...
    'TooltipString','faster',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@fasterFunction);

SCENE.handles.drawCoordSyst_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.coords+0.5,...
    'Units','pixels',...
    'Position',[236 80 27 20],...
    'TooltipString','draw coordinate system',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@drawCoordinateSystem);

SCENE.handles.drawLocalCoordSyst_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.localcoords+0.5,...
    'Units','pixels',...
    'Position',[264 80 27 20],...
    'TooltipString','draw local coordinate systems',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@drawLocalCoordinateSystems2);

SCENE.handles.drawGroundPlane_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.groundPlane,...
    'Units','pixels',...
    'Position',[292 80 27 20],...
    'TooltipString','hide ground plane',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@drawGroundPlane);

SCENE.handles.drawJointIDs_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.jointIDs+0.5,...
    'Units','pixels',...
    'Position',[320 80 27 20],...
    'TooltipString','show joint IDs',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@drawJointIDs);

SCENE.handles.drawSensorCoordSyst_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.sensorcoords+0.5,...
    'Units','pixels',...
    'Position',[348 80 27 20],...
    'TooltipString','draw sensor coordinate systems',...
    'BackgroundColor',SCENE.colors.buttons_group2, ...
    'CallBack',@drawSensorCoordinateSystems);

% SCENE.handles.drawSensorCoordSyst2_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
%     'CData',SCENE.buttons.sensorcoords+0.5,...
%     'Units','pixels',...
%     'Position',[348 80 27 20],...
%     'TooltipString','draw sensor coordinate systems',...
%     'BackgroundColor',SCENE.colors.buttons_group2, ...
%     'CallBack',@drawSensorCoordinateSystems2);

if SCENE.nmots>1
    SCENE.handles.spread_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
        'CData',SCENE.buttons.spread+0.5,...
        'Units','pixels',...
        'Position',[376 80 27 20],...
        'TooltipString','spread motions',...
        'BackgroundColor',SCENE.colors.buttons_group2, ...
        'CallBack',@spreadFunction);
end

SCENE.handles.render_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.renderScene,...
    'Units','pixels',...
    'Position',[SCENE.size(1)-41-2*32 7 30 20],...
    'TooltipString','render Scene to avi',...
    'BackgroundColor',[0.9 0.3 0], ...
    'CallBack',@renderMPProScene);

SCENE.handles.help_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'String','Help',...
    'Units','pixels',...
    'FontWeight','bold',...
    'HorizontalAlignment','center',...
    'Position',[SCENE.size(1)-41-32 6 30 22],...
    'CallBack',@helpButtonFunction);

SCENE.handles.quit_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
    'CData',SCENE.buttons.quit,...'String','Quit',...
    'Units','pixels',...
    'Position',[SCENE.size(1)-41 7 30 20],...
    'TooltipString','quit',...
    'BackgroundColor',[0.9,.0,.0], ...
    'CallBack',@closeFunction);

% SCENE.handles.axis_x_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
%     'String','x',...
%     'Units','pixels',...
%     'Position',[284 80 20 20],...
%     'FontWeight','bold',...
%     'TooltipString','set main axis to x',...
%     'BackgroundColor',[0.8,0.8,0.8], ...
%     'CallBack',@setMainAxisFunction);
% 
% SCENE.handles.axis_y_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
%     'String','y',...
%     'Units','pixels',...
%     'Position',[306 80 20 20],...
%     'FontWeight','bold',...
%     'TooltipString','set main axis to y',...
%     'BackgroundColor',[0.9,0.9,0.97], ...
%     'CallBack',@setMainAxisFunction);
% 
% SCENE.handles.axis_z_Button = uicontrol(SCENE.handles.control_Panel,'Style','Pushbutton', ...
%     'String','z',...
%     'Units','pixels',...
%     'Position',[328 80 20 20],...
%     'FontWeight','bold',...
%     'TooltipString','set main axis to z',...
%     'BackgroundColor',[0.8,0.8,0.8], ...
%     'CallBack',@setMainAxisFunction);

SCENE.handles.status_Panel = uipanel(...
    'Parent',SCENE.handles.control_Panel,'Units','pixels',...
    'Position',[2 2 SCENE.size(1)-8 30],...
    'BackgroundColor',[.97 .97 .97]);

SCENE.handles.curFrameLabel = uicontrol(SCENE.handles.status_Panel,'Style','Text', ...
    'String',sprintf(' 1 / %d (%.2f s)', SCENE.nframes,0),...
    'Units','pixels',...
    'TooltipString','current frame',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[.97 .97 .97],...
    'Position',[1 0 130 22]);

SCENE.handles.curSpeedLabel = uicontrol(SCENE.handles.status_Panel,'Style','Text', ...
    'String','x 1.000',...
    'Units','pixels',...
    'TooltipString','current speed',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[.97 .97 .97],...
    'Position',[150 0 40 22]);

% add frame markers above slider ------------------------------------------
if(SCENE.nframes > 1)
    SCENE.handles.sliderHandle = uicontrol(SCENE.handles.control_Panel,'Style','Slider', ...
        'String','Current Frame',...
        'Units','pixels',...
        'Max',SCENE.nframes,...
        'Min',1,...
        'Value',1,...
        'SliderStep',[1/SCENE.nframes (1/SCENE.size(1))*40],...
        'Position',[2 35 SCENE.size(1)-8 20],...
        'BackgroundColor',[.8 .8 .8], ...
        'CallBack',@moveFrameSliderFunction);
    
    if SCENE.nframes<=20
        numMarks = SCENE.nframes;
    else
        numMarks = 15;
    end
    for i=20:-1:5
        if mod(SCENE.nframes-1,i)==0
            numMarks=i+1;
            break;
        end
    end
    
    posFromLeft = 11;
    posFromRight = SCENE.size(1)-62;
    posFromLeft = posFromLeft-(posFromRight-posFromLeft)/(SCENE.nframes-1);
    
    for frameNum = 1:(SCENE.nframes-1)/(numMarks-1):SCENE.nframes
        uicontrol(SCENE.handles.control_Panel,'Style','Text',...
            'String',round(frameNum),'Units','pixels',...
            'FontSize',7,'BackgroundColor',[.97 .97 .97],...
            'Position',[posFromLeft+(round(frameNum)/SCENE.nframes)*(posFromRight-posFromLeft) 60 45 12]);
    end
end

if SCENE.status.spread
    for n=1:SCENE.nmots
        if SCENE.mots{n}.rotDataAvailable
            spreadVertices(n);
        else
            fprintf('Note: Transformation of point clouds (c3d) is not yet supported!\n');
        end
    end
    computeBoundingBoxSCENE();

    set(SCENE.handles.spread_Button, 'CData',SCENE.buttons.spread,'TooltipString','unspread motions');
    SCENE.status.spread = true;
    if SCENE.status.groundPlane_drawn
        computeGroundPlane(SCENE.boundingBox);
    end
    renewAxisDimensions(SCENE.boundingBox);
    setFramePro(SCENE.status.curFrame);
end

%% callback functions -----------------------------------------------------

    function playReverseFunction(varargin)
        if (SCENE.status.curFrame == 1)
            SCENE.status.curFrame = SCENE.nframes;
        end
        SCENE.status.reverse    = true;
        SCENE.status.running    = true;
        SCENE.status.timeStamp  = (SCENE.status.curFrame)/SCENE.samplingRate;
        SCENE.timeOffset        = SCENE.status.timeStamp;
        
        tic;
        while SCENE.status.running && (SCENE.status.curFrame>1 || SCENE.status.looped)
            nextFrame = getNextFrame_local();
            if SCENE.status.running
                setFramePro(nextFrame);
                drawnow; 
                SCENE.status.timeStamp = SCENE.timeOffset-toc*SCENE.status.speed;
            end
        end
        SCENE.status.running = false;
    end

    function pauseFunction(varargin)
        SCENE.status.running = false;
    end

    function playFunction(varargin)
        if (SCENE.status.curFrame == SCENE.nframes)
            SCENE.status.curFrame = 1;
        end
        SCENE.status.reverse    = false;
        SCENE.status.running    = true;
        SCENE.status.timeStamp  = (SCENE.status.curFrame)/SCENE.samplingRate;
        SCENE.timeOffset        = SCENE.status.timeStamp;
         
        tic;
        while SCENE.status.running && (SCENE.status.curFrame<SCENE.nframes || SCENE.status.looped)
            nextFrame               = getNextFrame_local();
            if SCENE.status.running
                setFramePro(nextFrame);
                drawnow;
                SCENE.status.timeStamp = SCENE.timeOffset+toc*SCENE.status.speed;
            end
        end
        SCENE.status.running = false;
    end

    function gotoFirstFunction(varargin)
        SCENE.status.running    = false;
        SCENE.status.curFrame   = 1;
        setFramePro(1);
        drawnow();
    end

    function gotoLastFunction(varargin)
        SCENE.status.running    = false;
        SCENE.status.curFrame   = SCENE.nframes;
        setFramePro(SCENE.nframes);
        drawnow();
    end

    function closeFunction(varargin)
        SCENE.status.running = false;
        close;
        SCENE.objects = [];
        SCENE.mots    = [];
        SCENE.nmots   = 0;
        SCENE.skels   = [];
        SCENE.nskels  = 0;        
%         clear global SCENE;
    end

    function slowerFunction(varargin)
        if (SCENE.status.speed > 0.125)
            SCENE.status.speed = SCENE.status.speed/2;
            set(SCENE.handles.curSpeedLabel,'String',...
                sprintf('x %1.3f',SCENE.status.speed));
            SCENE.status.timeStamp = (SCENE.status.curFrame)/SCENE.samplingRate;
            SCENE.timeOffset   = SCENE.status.timeStamp;
            tic;
        end
    end

    function fasterFunction(varargin)
        if (SCENE.status.speed < 8)
            SCENE.status.speed = SCENE.status.speed*2;
            set(SCENE.handles.curSpeedLabel,'String',...
                sprintf('x %1.3f',SCENE.status.speed));
            SCENE.status.timeStamp = (SCENE.status.curFrame)/SCENE.samplingRate;
            SCENE.timeOffset   = SCENE.status.timeStamp;
            tic;
        end
    end

    function loopFunction(varargin)
        if (SCENE.status.looped)
            SCENE.status.looped = false;
            set(SCENE.handles.loop_Button, 'CData',SCENE.buttons.unlooped,'TooltipString','loop');
        else
            SCENE.status.looped = true;
            set(SCENE.handles.loop_Button, 'CData',SCENE.buttons.looped,'TooltipString','no loop');
        end
    end

    function drawJointIDs(varargin)
        if SCENE.status.jointIDs_drawn
            SCENE.status.jointIDs_drawn = false;
            for ii=1:SCENE.nmots
                arrayfun(@(x) delete(x), SCENE.mots{ii}.jointID_handles);
            end
            set(SCENE.handles.drawJointIDs_Button,'CData',SCENE.buttons.jointIDs+0.5,'TooltipString','show joint IDs');
        else
            SCENE.status.jointIDs_drawn = true;
            if ~SCENE.status.running
                setFramePro(SCENE.status.curFrame);
            end
            set(SCENE.handles.drawJointIDs_Button,'CData',SCENE.buttons.jointIDs,'TooltipString','hide joint IDs');
        end
    end

    function moveFrameSliderFunction(varargin)
        
        if (SCENE.status.running)
            SCENE.status.running = false;
        end
        
        curFrame            = round(get(SCENE.handles.sliderHandle,'Value'));
        SCENE.status.timeStamp = curFrame/SCENE.samplingRate;
        SCENE.timeOffset    = SCENE.status.timeStamp;
        
        setFramePro(curFrame);
        drawnow;
    end

    function spreadFunction(varargin)       
        if SCENE.status.spread == false

            for m=1:SCENE.nmots
                if SCENE.mots{m}.rotDataAvailable
                    spreadVertices(m);
                else
                    fprintf('Note: Transformation of point clouds (c3d) is not yet supported!\n');
                end
            end
            computeBoundingBoxSCENE();
            
            set(SCENE.handles.spread_Button, 'CData',SCENE.buttons.spread,'TooltipString','unspread motions');
            SCENE.status.spread = true;
            if SCENE.status.groundPlane_drawn
                computeGroundPlane(SCENE.boundingBox);
            end
            renewAxisDimensions(SCENE.boundingBox);
        else

            for m=1:SCENE.nmots
                if SCENE.mots{m}.rotDataAvailable
                    unspreadVertices(m);
                end
            end
            computeBoundingBoxSCENE();
            
            set(SCENE.handles.spread_Button, 'CData',SCENE.buttons.spread+0.5,'TooltipString','spread motions');
            SCENE.status.spread = false;
            if SCENE.status.groundPlane_drawn
                computeGroundPlane(SCENE.boundingBox);
            end
            renewAxisDimensions(SCENE.boundingBox);
        end
        setFramePro(SCENE.status.curFrame);
    end

%     function setMainAxisFunction(varargin)
%         buttonHandle = get(varargin{1,1});
%         mA = buttonHandle.String;
%         switch(mA)
%             case 'x'
%                 SCENE.status.mainAxis = 'x';
%                 set(SCENE.handles.axis_x_Button,'BackgroundColor',[.9 .9 .97]);
%                 set(SCENE.handles.axis_y_Button,'BackgroundColor',[.8 .8 .8]);
%                 set(SCENE.handles.axis_z_Button,'BackgroundColor',[.8 .8 .8]);
%             case 'y'
%                 SCENE.status.mainAxis = 'y';
%                 set(SCENE.handles.axis_x_Button,'BackgroundColor',[.8 .8 .8]);
%                 set(SCENE.handles.axis_y_Button,'BackgroundColor',[.9 .9 .97]);
%                 set(SCENE.handles.axis_z_Button,'BackgroundColor',[.8 .8 .8]);
%             case 'z'
%                 SCENE.status.mainAxis = 'z';
%                 set(SCENE.handles.axis_x_Button,'BackgroundColor',[.8 .8 .8]);
%                 set(SCENE.handles.axis_y_Button,'BackgroundColor',[.8 .8 .8]);
%                 set(SCENE.handles.axis_z_Button,'BackgroundColor',[.9 .9 .97]);
%         end
%         cameratoolbar(fig, 'SetCoordSys',SCENE.status.mainAxis);
%     end

    function drawGroundPlane(varargin)
        if SCENE.status.groundPlane_drawn
            SCENE.status.groundPlane_drawn = false;
%             set(SCENE.handles.groundPlane,'Visible','off');
            set(SCENE.handles.drawGroundPlane_Button,'CData',SCENE.buttons.groundPlane+0.5,'TooltipString','draw ground plane');
            set(SCENE.handles.groundPlane,'FaceAlpha',0,'EdgeColor','none');
        else
            SCENE.status.groundPlane_drawn = true;
%             set(SCENE.handles.groundPlane,'Visible','on');
            set(SCENE.handles.drawGroundPlane_Button,'CData',SCENE.buttons.groundPlane,'TooltipString','hide ground plane');
            set(SCENE.handles.groundPlane,'FaceAlpha',0.7,'EdgeColor','black');
        end
    end

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
                    cameratoolbar(fig, 'SetCoordSys',SCENE.status.mainAxis);
                    cameratoolbar(fig, 'SetMode','orbit');
%                     set(cam_Status_Label,'String','orbit');
                end
            case 'alt'
                if(~SCENE.keyEvents.altKeyDown)
                    SCENE.keyEvents.altKeyDown = true;
                    cameratoolbar(fig, 'SetCoordSys',SCENE.status.mainAxis);
                    cameratoolbar(fig, 'SetMode','pan');
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
                cameratoolbar(fig, 'SetCoordSys','none');
                cameratoolbar(fig, 'SetMode','nomode');
            case 'alt'
                SCENE.keyEvents.altKeyDown = false;
                cameratoolbar(fig, 'SetCoordSys','none');
                cameratoolbar(fig, 'SetMode','nomode');
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

    function helpButtonFunction(src,evnt)
%                 msgbox(helpDlg,'Help','help');
        helpFig = figure( 'Visible','on',...
            'Name','Help',...
            'NumberTitle','off',...
            'Menu','none',...
            'Position',[400,200,250,400],...
            'Resize', 'on', ...
            'Color',[.92 .95 .95]);
        uicontrol(helpFig,'Style','Text', ...
            'String',helpDlg,...
            'Units','pixels',...
            'HorizontalAlignment','left',...
            'BackgroundColor',[.97 .97 .97],...
            'Position',[0 0 250 400]);
    end
end

%% local functions --------------------------------------------------------

function nextFrame = getNextFrame_local()
    global SCENE;
    
    framesToDrop = SCENE.status.timeStamp*SCENE.samplingRate-SCENE.status.curFrame;
    
    if SCENE.status.reverse
        nextFrame = SCENE.status.curFrame+round(framesToDrop)-1;
    else
        nextFrame = SCENE.status.curFrame+round(framesToDrop)+1;
    end

    if nextFrame<=0
        if SCENE.status.looped
            nextFrame   = SCENE.nframes;
        else
            nextFrame = 1;
        end
    elseif nextFrame>SCENE.nframes
        if SCENE.status.looped
            nextFrame   = 1;%mod(nextFrame,SCENE.nframes);
        else
            nextFrame = SCENE.nframes;
        end
    end

    if (framesToDrop<0 && ~SCENE.status.reverse) || (framesToDrop>0 && SCENE.status.reverse)
        pause(abs(framesToDrop/SCENE.samplingRate));
    end
end

function renewAxisDimensions(bb)
    diagonal = sqrt(sum((bb([1,3,5])-bb([2,4,6])).^2))/2;
    
    % center of the boundingbox's bottom
    xc = bb(1) + (bb(2) - bb(1))/2;
    yc = bb(3) + (bb(4) - bb(3))/2;
%     %zc = bb(5) + (bb(6) - bb(5))/2;
    axisDimensions = [xc-diagonal xc+diagonal yc-diagonal yc+diagonal];
    axis (axisDimensions);
end
