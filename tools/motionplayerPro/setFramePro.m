function setFramePro(frame)
    global SCENE;
    for j=1:SCENE.nmots
        if ~SCENE.status.running || (SCENE.status.curFrame<SCENE.mots{j}.nframes && SCENE.status.curFrame>1)
            nrOfNodes = size(SCENE.mots{j}.vertices{2},1)/3;
            
            if isfield(SCENE.mots{j},'colors')
               
                for cj=1:numel(SCENE.mots{j}.joint_handles)
                    if ishandle(SCENE.mots{j}.joint_handles(cj))
                        cf = min(SCENE.status.curFrame,size(SCENE.mots{j}.colors,1));
                        set(SCENE.mots{j}.joint_handles(cj), 'FaceColor',SCENE.mots{j}.colors(cf,:));
                    end
                end
                
            end
            
            
            for i = 1:SCENE.mots{j}.njoints
                if i==1 && SCENE.mots{j}.rotDataAvailable
                    p = SCENE.mots{j}.vertices{i+1}(1:3,max(1,min(frame,SCENE.mots{j}.nframes)));
                else
                    v = reshape(SCENE.mots{j}.vertices{i}(:,max(1,min(frame,SCENE.mots{j}.nframes))),3,nrOfNodes)';
                    set(SCENE.mots{j}.joint_handles(i),'Vertices',v);
                    p = v(end,:);
                end
                
                if SCENE.status.jointIDs_drawn

                        if SCENE.mots{j}.rotDataAvailable
                            str = num2str(i);
                        else
                            str = ['  ' num2str(i) ':' SCENE.skels{j}.nameMap{i,1}];
                        end
                        
                        if ishandle(SCENE.mots{j}.jointID_handles(i))
                            set(SCENE.mots{j}.jointID_handles(i),'Position',p); 
                        else
                            SCENE.mots{j}.jointID_handles(i) = text('Position',p,'String',str,'interpreter','none');
                        end
                        
                end
            end 
            
            if SCENE.status.localCoordSyst1_drawn || SCENE.status.localCoordSyst2_drawn
                if SCENE.mots{j}.rotDataAvailable
                    for i=2:SCENE.mots{j}.njoints
                        parent = SCENE.skels{j}.nodes(i).parentID;
                        % if using function drawLocalCoordinateSystems
                        % instead of function drawLocalCoordinateSystems2
                        % then replace parent by i and start counting at 1
                        if strcmp(SCENE.bones,'sticks')
                            p = mean(reshape(SCENE.mots{j}.vertices{i}(1:12,frame),3,4),2);
                        else
                            p = SCENE.mots{j}.vertices{i}(1:3,frame);
                        end
                        
                        if SCENE.status.localCoordSyst1_drawn
                            q = SCENE.mots{j}.localSystems{parent}(:,frame);
                        else
                            q_axis  = C_euler2quat(SCENE.skels{j}.nodes(i).axis([3,2,1])*pi/180);
                            q_local = SCENE.mots{j}.localSystems{parent}(:,frame);
                            q = C_quatmult(q_local,q_axis);
                        end
                        
                        if SCENE.status.spread
                            q = C_quatmult(SCENE.mots{j}.rotOffset,q);
                        end

                        xyz = C_quatrot([SCENE.lengthOfLocalCoordSystAxes 0 0; 0 SCENE.lengthOfLocalCoordSystAxes 0; 0 0 SCENE.lengthOfLocalCoordSystAxes],q);

                        set(SCENE.handles.localCoordSystems(j,i,1),'XData',[p(1) p(1)+xyz(1,1)],'YData',[p(2) p(2)+xyz(2,1)],'ZData',[p(3) p(3)+xyz(3,1)]);
                        set(SCENE.handles.localCoordSystems(j,i,2),'XData',[p(1) p(1)+xyz(1,2)],'YData',[p(2) p(2)+xyz(2,2)],'ZData',[p(3) p(3)+xyz(3,2)]);
                        set(SCENE.handles.localCoordSystems(j,i,3),'XData',[p(1) p(1)+xyz(1,3)],'YData',[p(2) p(2)+xyz(2,3)],'ZData',[p(3) p(3)+xyz(3,3)]);

                    end
                end
            end
            
            if SCENE.status.sensorCoordSyst_drawn
                
                sensors = fieldnames(SCENE.mots{j}.virtualSensors);
                
                for i=1:numel(sensors)
                    
                    qa = SCENE.mots{j}.virtualSensors.(sensors{i}).rotation(:,frame);
                    qp = qa;

                    if SCENE.status.spread
                        qp = C_quatmult(SCENE.mots{j}.rotOffset,qp);
                    end
                    
                    if SCENE.mots{j}.rotDataAvailable
                        offset = SCENE.virtualSensors.(sensors{i}).posOffset_amc;
                        ids = SCENE.virtualSensors.(sensors{i}).jointIDs_amc;
                        p   = SCENE.mots{j}.vertices{ids}(end-2:end,frame) + C_quatrot(offset,qp);
                    else
                        offset = SCENE.virtualSensors.(sensors{i}).posOffset_c3d;
                        ids = SCENE.virtualSensors.(sensors{i}).jointIDs_c3d;
                        p = (SCENE.mots{j}.jointTrajectories{ids(1)}(:,frame) + SCENE.mots{j}.jointTrajectories{ids(2)}(:,frame))/2 ...
                            +C_quatrot(offset,qp);
                    end
                    
                    a = SCENE.mots{j}.virtualSensors.(sensors{i}).globalAcc(:,frame);
                    a = C_quatrot(a,C_quatinv(qa))/SCENE.gravity*30;

                    xyz = C_quatrot([a(1) 0 0; 0 a(2) 0; 0 0 a(3)],qp);

                    set(SCENE.handles.sensorCoordSystems(j,i,1),'XData',[p(1) p(1)+xyz(1,1)],'YData',[p(2) p(2)+xyz(2,1)],'ZData',[p(3) p(3)+xyz(3,1)]);
                    set(SCENE.handles.sensorCoordSystems(j,i,2),'XData',[p(1) p(1)+xyz(1,2)],'YData',[p(2) p(2)+xyz(2,2)],'ZData',[p(3) p(3)+xyz(3,2)]);
                    set(SCENE.handles.sensorCoordSystems(j,i,3),'XData',[p(1) p(1)+xyz(1,3)],'YData',[p(2) p(2)+xyz(2,3)],'ZData',[p(3) p(3)+xyz(3,3)]);

                end
            end

        end
               
    end
    
    if ~isempty(SCENE.objects)
        objects = fieldnames(SCENE.objects);
        nrOfObj = numel(objects);

        for j=1:nrOfObj
            for j2=1:SCENE.objects.(objects{j}).counter
                if ~SCENE.status.running || (SCENE.status.curFrame<SCENE.objects.(objects{j}).nframes{j2} && SCENE.status.curFrame>1)
                    f = max(1,min(frame,SCENE.objects.(objects{j}).nframes{j2}));
                    switch objects{j}
                        case 'tetra'
                            alphaValues = ones(size(SCENE.objects.tetra.procdata{j2},1),1);
                            if ~isempty(SCENE.objects.tetra.alpha{j2})
                                if numel(SCENE.objects.tetra.alpha{j2})==1
                                    alphaValues = alphaValues * SCENE.objects.tetra.alpha{j2};
                                elseif size(SCENE.objects.tetra.alpha{j2},1)==1
                                    alphaValues = alphaValues * SCENE.objects.tetra.alpha{j2}(f);
                                elseif size(SCENE.objects.tetra.alpha{j2},2)==1
                                    alphaValues = SCENE.objects.tetra.alpha{j2}(:,1);
                                else
                                    alphaValues = SCENE.objects.tetra.alpha{j2}(:,f);
                                end
                            end
                            for i=1:numel(SCENE.objects.tetra.procdata{j2})
                                v = reshape(SCENE.objects.tetra.procdata{j2}{i}(:,f),3,size(SCENE.objects.tetra.procdata{j2}{i},1)/3);
                                set(SCENE.handles.tetra{j2}(i),'Vertices',v','FaceAlpha',alphaValues(i));
                            end
                        case {'arrow'}
                            set(SCENE.handles.(objects{j}){j2},...
                                'XData',SCENE.objects.(objects{j}).procdata{j2}(1:3:end,f,1),...
                                'YData',SCENE.objects.(objects{j}).procdata{j2}(2:3:end,f,1),...
                                'ZData',SCENE.objects.(objects{j}).procdata{j2}(3:3:end,f,1),...
                                'UData',SCENE.objects.(objects{j}).procdata{j2}(1:3:end,f,2),...
                                'VData',SCENE.objects.(objects{j}).procdata{j2}(2:3:end,f,2),...
                                'WData',SCENE.objects.(objects{j}).procdata{j2}(3:3:end,f,2));
                        case {'dot','cross','circle'}
                            set(SCENE.handles.(objects{j}){j2},...
                                'XData',SCENE.objects.(objects{j}).procdata{j2}(1:3:end,f),...
                                'YData',SCENE.objects.(objects{j}).procdata{j2}(2:3:end,f),...
                                'ZData',SCENE.objects.(objects{j}).procdata{j2}(3:3:end,f));
                        case {'line'}
                            nrOfLines = size(SCENE.objects.(objects{j}).procdata{j2},1);
                            nrOfJoints = size(SCENE.objects.(objects{j}).procdata{j2}{1},1)/3;
                            n=0;
                            color = rgb(SCENE.objects.line.color{j2});
                            for n1=1:nrOfLines
                                for n2=1:nrOfJoints
                                    n=n+1;
                                    if ~isempty(SCENE.objects.line.alpha{j2})
                                        w = SCENE.objects.line.alpha{j2}(n1,f);
                                        color = w * color + (1-w) * [1 1 1];
                                    end
                                    set(SCENE.handles.line{j2}(n),...
                                        'XData',SCENE.objects.line.procdata{j2}{n1,f}(3*n2-2,:),...
                                        'YData',SCENE.objects.line.procdata{j2}{n1,f}(3*n2-1,:),...
                                        'ZData',SCENE.objects.line.procdata{j2}{n1,f}(3*n2,:),...
                                        'Color',color);
                                end
                            end
                    end
                end
            end
        end
    end
    
    if frame==1
        SCENE.status.timeStamp     = 0;
        SCENE.timeOffset    = 1/SCENE.samplingRate;
        tic;
    elseif frame==SCENE.nframes
        SCENE.status.timeStamp = SCENE.nframes/SCENE.samplingRate;
        SCENE.timeOffset    = SCENE.status.timeStamp;
        tic;
    end
    
    SCENE.status.curFrame = frame;
    
    if ishandle(SCENE.handles.sliderHandle), set(SCENE.handles.sliderHandle,'Value',frame); end
    if ishandle(SCENE.handles.curFrameLabel), set(SCENE.handles.curFrameLabel,'String',...
        sprintf(' %d / %d (%.2f s)',SCENE.status.curFrame,SCENE.nframes,SCENE.status.timeStamp)); end

    %% Hack for moving camera
    if isfield(SCENE,'camPosition') && isfield(SCENE,'camTarget')
        set(gca,'CameraPosition',SCENE.camPosition(:,frame) ,...
                'CameraTarget',SCENE.camTarget(:,frame))
    end

    %% set frame bar in additional figure
    if isfield(SCENE,'addFig')
        if(ishandle(SCENE.addFig.fig))
            
            axYsize = get(SCENE.addFig.axes,'YLim');
            %             axXsize = get(SCENE.addFig.axes,'XLim');
            if ~iscell(axYsize)
                axYsize = {axYsize};
            end
            curTime = frame/ SCENE.samplingRate;% ((axXsize(2)-axXsize(1))/SCENE.nframes);
            
            
            if isfield(SCENE.addFig,'timeslider')
                for curax = 1:numel(axYsize)
                    set(SCENE.addFig.timeslider{curax},'XData',[curTime curTime]);
                end
            else
                figure(SCENE.addFig.fig);
                colormap hot;
                set(SCENE.addFig.fig,'color',SCENE.colors.backgroundColor);
                for curax = 1:numel(axYsize)
                    axes(SCENE.addFig.axes(curax));
                    SCENE.addFig.timeslider{curax} = line([curTime curTime],axYsize{curax},'color','green','linewidth',2);
                end
                figure(SCENE.handles.fig);
            end
        else
            warning('Additional figure: Handles are not valid any more. Removing from scene!');
            SCENE = rmfield(SCENE,'addFig');
        end
    end
end
