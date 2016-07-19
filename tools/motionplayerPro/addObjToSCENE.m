function addObjToSCENE(varargin)

global SCENE;

if isempty(SCENE) || ~ishandle(SCENE.handles.fig)
    SCENE               = defaultSCENE();
    SCENE.handles.fig   = MPP_GUI();
end

% Parsing the input ---------------------------------------------------
nOldMots  = SCENE.nmots;
nNewSkels = 0;
nNewMots  = 0;
for i=1:2:nargin
    switch varargin{i}
        case 'handle'
            if ishandle(varargin{i+1})
                
                handletype = get(varargin{i+1},'type');
                
                switch handletype
                    case 'axes'
                        SCENE.addFig.axes    = varargin{i+1};
                        SCENE.addFig.fig     = get(varargin{i+1},'parent');
                    case 'figure'
                        SCENE.addFig.fig  = varargin{i+1};
                        childs = findall(SCENE.addFig.fig,'type','axes');
                        SCENE.addFig.axes = childs;
                    otherwise
                        error('Graphics handle is no axes or figure!');
                end
            else
                error('No valid graphics handle!');
            end
        case 'skel'
            if iscell(varargin{i+1})
                nNewSkels = numel(varargin{i+1});
                skel = varargin{i+1};
                SCENE.skels(SCENE.nskels+1:SCENE.nskels+nNewSkels)=varargin{i+1};
                SCENE.nskels = SCENE.nskels+nNewSkels;
            else
                nNewSkels = 1;
                skel = {varargin{i+1}};
            end
        case 'mot'
            if iscell(varargin{i+1})
                nNewMots    = numel(varargin{i+1});
                SCENE.mots(SCENE.nmots+1:SCENE.nmots+nNewMots) = varargin{i+1};
                SCENE.nmots = SCENE.nmots+nNewMots;
            else
                nNewMots    = 1;
                SCENE.nmots = SCENE.nmots+1;
                SCENE.mots{SCENE.nmots} = varargin{i+1};
            end
        case 'obj'
            fprintf('Precomputing vertices for objects... ');
            tic;
            if ~iscell(varargin{i+1}), varargin{i+1}={varargin{i+1}}; end
            nrOfObj = numel(varargin{i+1});
            
            for j=1:nrOfObj
                
                objType = varargin{i+1}{j}.type;
                
                if isfield(SCENE.objects,objType)
                    SCENE.objects.(objType).counter=SCENE.objects.(objType).counter+1;
                else
                    SCENE.objects.(objType).counter=1;
                end
                counter = SCENE.objects.(objType).counter;
                if isfield(varargin{i+1}{j},'color') && ~isempty(varargin{i+1}{j}.color)
                    SCENE.objects.(objType).color{counter} = varargin{i+1}{j}.color;
                else
                    SCENE.objects.(objType).color{counter} = SCENE.obj_default.color;
                end
                if isfield(varargin{i+1}{j},'alpha') && ~isempty(varargin{i+1}{j}.alpha)
                    SCENE.objects.(objType).alpha{counter} = varargin{i+1}{j}.alpha;
                else
                    SCENE.objects.(objType).alpha{counter} = [];
                end
                if isfield(varargin{i+1}{j},'size') && ~isempty(varargin{i+1}{j}.size)
                    SCENE.objects.(objType).size{counter} = varargin{i+1}{j}.size;
                else
                    SCENE.objects.(objType).size{counter} = SCENE.obj_default.size;
                end
                if isfield(varargin{i+1}{j},'boundingBox') && ~isempty(varargin{i+1}{j}.boundingBox)
                    bb = varargin{i+1}{j}.boundingBox;
                    computeObjBoundingBox = false;
                else
                    bb = [inf;-inf;inf;-inf;inf;-inf];
                    computeObjBoundingBox = true;
                end
                SCENE.objects.(objType).nframes{counter}     = size(varargin{i+1}{j}.data,2);
                
                switch objType
                    %                         case 'sphere'
                    %                             numfaces = 9;
                    %                             [x,y,z]=sphere(numfaces);
                    %
                    %                             x=x*SCENE.objects.(objType).size{counter};
                    %                             y=y*SCENE.objects.(objType).size{counter};
                    %                             z=z*SCENE.objects.(objType).size{counter};
                    %
                    %                             SCENE.objects.(objType).procdata{counter} = varargin{i+1}{j}.data;
                    case 'tetra'
                        coords = [1 -1 -1 1;1 -1 1 -1;-1 -1 1 1];
                        faces  = [1 2 3;1 2 4;1 3 4;2 3 4];
                        coords = coords*SCENE.objects.(objType).size{counter};
                        nrOfTetras = size(varargin{i+1}{j}.data,1)/3;
                        SCENE.objects.tetra.procdata{counter} = cell(nrOfTetras,1);
                        for n=1:nrOfTetras
                            SCENE.objects.tetra.procdata{counter}{n} = repmat(varargin{i+1}{j}.data(n*3-2:n*3,:),size(coords,2),1);
                            
                            for m=1:numel(coords)
                                SCENE.objects.tetra.procdata{counter}{n}(m,:) = SCENE.objects.tetra.procdata{counter}{n}(m,:)+coords(m);
                            end
                            
                            if computeObjBoundingBox
                                bb = [min(bb(1),min(SCENE.objects.tetra.procdata{counter}{n}(1:3:end)));...
                                    max(bb(2),max(SCENE.objects.tetra.procdata{counter}{n}(1:3:end)));...
                                    min(bb(3),min(SCENE.objects.tetra.procdata{counter}{n}(2:3:end)));...
                                    max(bb(4),max(SCENE.objects.tetra.procdata{counter}{n}(2:3:end)));...
                                    min(bb(5),min(SCENE.objects.tetra.procdata{counter}{n}(3:3:end)));...
                                    max(bb(6),max(SCENE.objects.tetra.procdata{counter}{n}(3:3:end)))];
                            end
                            
                            f = max(1,min(SCENE.status.curFrame,SCENE.objects.tetra.nframes{counter}));
                            alphaValues = ones(size(SCENE.objects.tetra.procdata{counter},1),1);
                            if ~isempty(SCENE.objects.tetra.alpha{counter})
                                if numel(SCENE.objects.tetra.alpha{counter})==1
                                    alphaValues = alphaValues * SCENE.objects.tetra.alpha{counter};
                                elseif size(SCENE.objects.tetra.alpha{counter},1)==1
                                    alphaValues = alphaValues * SCENE.objects.tetra.alpha{counter}(f);
                                elseif size(SCENE.objects.tetra.alpha{counter},2)==1
                                    alphaValues = SCENE.objects.tetra.alpha{counter}(:,1);
                                else
                                    alphaValues = SCENE.objects.tetra.alpha{counter}(:,f);
                                end
                            end
                            v = reshape(SCENE.objects.tetra.procdata{counter}{n}(:,f),3,size(coords,2));
                            SCENE.handles.tetra{counter}(n) = patch('Vertices',v','Faces',faces,...
                                'FaceColor',SCENE.objects.(objType).color{counter},...
                                'FaceAlpha',alphaValues(n), ...
                                'EdgeColor','none');
                            
                        end
                    case {'arrow'}
                        SCENE.objects.(objType).procdata{counter} = varargin{i+1}{j}.data;
                        
                        hold all;
                        f = max(1,min(SCENE.status.curFrame,SCENE.objects.(objType).nframes{counter}));
                        SCENE.handles.(objType){counter} = quiver3(...
                            SCENE.objects.(objType).procdata{counter}(1:3:end,f,1),...
                            SCENE.objects.(objType).procdata{counter}(2:3:end,f,1),...
                            SCENE.objects.(objType).procdata{counter}(3:3:end,f,1),...
                            SCENE.objects.(objType).procdata{counter}(1:3:end,f,2),...
                            SCENE.objects.(objType).procdata{counter}(2:3:end,f,2),...
                            SCENE.objects.(objType).procdata{counter}(3:3:end,f,2),...
                            'color',SCENE.objects.(objType).color{counter});
                        set( SCENE.handles.(objType){counter}, ...
                            'linewidth',SCENE.objects.(objType).size{1});
                        
                    case {'dot','cross','circle'}
                        SCENE.objects.(objType).procdata{counter} = varargin{i+1}{j}.data;
                        if computeObjBoundingBox
                            bb = [min(bb(1),min(SCENE.objects.(objType).procdata{counter}(1:3:end)));...
                                max(bb(2),max(SCENE.objects.(objType).procdata{counter}(1:3:end)));...
                                min(bb(3),min(SCENE.objects.(objType).procdata{counter}(2:3:end)));...
                                max(bb(4),max(SCENE.objects.(objType).procdata{counter}(2:3:end)));...
                                min(bb(5),min(SCENE.objects.(objType).procdata{counter}(3:3:end)));...
                                max(bb(6),max(SCENE.objects.(objType).procdata{counter}(3:3:end)))];
                        end
                        
                        switch objType
                            case 'dot',     lineSpec = '.';
                            case 'cross',   lineSpec = 'x';
                            case 'circle',  lineSpec = 'o';
                            otherwise
                                error('Unknown obj type');
                        end
                        
                        hold all;
                        f = max(1,min(SCENE.status.curFrame,SCENE.objects.(objType).nframes{counter}));
                        SCENE.handles.(objType){counter} = plot3(SCENE.objects.(objType).procdata{counter}(1:3:end,f),...
                            SCENE.objects.(objType).procdata{counter}(2:3:end,f),...
                            SCENE.objects.(objType).procdata{counter}(3:3:end,f),...
                            lineSpec,'color',SCENE.objects.(objType).color{counter},...
                            'LineWidth',SCENE.objects.(objType).size{counter});
                    case {'line'}
                        SCENE.objects.(objType).procdata{counter} = varargin{i+1}{j}.data;
                        if computeObjBoundingBox
                            for n=1:numel(SCENE.objects.(objType).procdata{counter})
%                                 if isempty(SCENE.objects.(objType).procdata{counter}(n))
%                                     break
%                                 end
%                                 bb = [min(bb(1),min(SCENE.objects.(objType).procdata{counter}(1:3:end)));...
%                                     max(bb(2),max(SCENE.objects.(objType).procdata{counter}(1:3:end)));...
%                                     min(bb(3),min(SCENE.objects.(objType).procdata{counter}(2:3:end)));...
%                                     max(bb(4),max(SCENE.objects.(objType).procdata{counter}(2:3:end)));...
%                                     min(bb(5),min(SCENE.objects.(objType).procdata{counter}(3:3:end)));...
%                                     max(bb(6),max(SCENE.objects.(objType).procdata{counter}(3:3:end)))];

                                if isempty(SCENE.objects.(objType).procdata{counter}{n})
                                    break
                                end
                                bb = [min(bb(1),min(SCENE.objects.(objType).procdata{counter}{n}(1:3:end)));...
                                    max(bb(2),max(SCENE.objects.(objType).procdata{counter}{n}(1:3:end)));...
                                    min(bb(3),min(SCENE.objects.(objType).procdata{counter}{n}(2:3:end)));...
                                    max(bb(4),max(SCENE.objects.(objType).procdata{counter}{n}(2:3:end)));...
                                    min(bb(5),min(SCENE.objects.(objType).procdata{counter}{n}(3:3:end)));...
                                    max(bb(6),max(SCENE.objects.(objType).procdata{counter}{n}(3:3:end)))];
                            end
                        end
                        hold all;
                        f = max(1,min(SCENE.status.curFrame,SCENE.objects.(objType).nframes{counter}));
                        nrOfLines = size(varargin{i+1}{j}.data,1);
                        %%%nrOfJoints = 31;
                        nrOfJoints = size(varargin{i+1}{j}.data{1},1)/3;
                        n=0;
                        color = rgb(SCENE.objects.line.color{counter});
                        for n1=1:nrOfLines
                            for n2=1:nrOfJoints
                                n=n+1;
                                if ~isempty(SCENE.objects.line.alpha{counter})
                                    w = SCENE.objects.line.alpha{counter}(n1,f);
                                    color = w * color + (1-w) * [1 1 1];
                                end
                                SCENE.handles.(objType){counter}(n) = plot3(SCENE.objects.line.procdata{counter}{n1,f}(3*n2-2,:),...
                                    SCENE.objects.line.procdata{counter}{n1,f}(3*n2-1,:),...
                                    SCENE.objects.line.procdata{counter}{n1,f}(3*n2,:),...
                                    '-','color',color);
                            end
                        end
                end
                SCENE.objects.(objType).boundingBox{counter} = bb;
                SCENE.nframes = max(SCENE.nframes,SCENE.objects.(objType).nframes{counter});
            end
            fprintf('finished in %.3f seconds.\n',toc);
    end
end

if nNewSkels==1
    SCENE.skels(SCENE.nskels+1:SCENE.nmots) = skel;
    SCENE.nskels = SCENE.nmots;
end

if SCENE.nmots~=SCENE.nskels
    error('Number of skels must be 1 or equal number of mots!');
end


if nNewMots>0
    if SCENE.nmots>1 && ishandle(SCENE.handles.spread_Button)
        set(SCENE.handles.spread_Button,'Visible','on');
    end
    % Precomputing vertices -------------------------------------------
    fprintf('Precomputing vertices for motions... ');
    tic;
    for i=nOldMots+1:SCENE.nmots
        SCENE.mots{i} = computeVertices(SCENE.skels{i},SCENE.mots{i},SCENE.scaleFactorForC3D,SCENE.bones);
    end
    fprintf('finished in %.3f seconds.\n',toc);
    
    for i=nOldMots+1:SCENE.nmots
        
        SCENE.nframes                   = max(SCENE.nframes,SCENE.mots{i}.nframes);
        SCENE.mots{i}.boundingBox       = computeBoundingBoxPRO(SCENE.mots{i});
        
        SCENE.samplingRate              = max(SCENE.samplingRate,SCENE.mots{i}.samplingRate);
        SCENE.mots{i}.joint_handles     = -ones(SCENE.mots{i}.njoints,1);
        
        if SCENE.mots{i}.rotDataAvailable
            p = C_quatrot([0;0;1],SCENE.mots{i}.rotationQuat{1}(:,1));
            p(2)    = 0;
            p       = normalizeColumns(p);
            angle   = real(acos(dot(p,normalizeColumns(SCENE.ahead))));
            if isnan(angle), angle=0; end
            if acos(dot([0;1;0],normalizeColumns(cross(p,SCENE.ahead))))>pi/2
                angle = -angle;
            end
            SCENE.mots{i}.rotOffset = rotquat(angle,'y');
        else
            SCENE.mots{i}.rotOffset = [1;0;0;0];
        end
        
        if SCENE.nmots>1 % the interpolate skeleton colors
            c = (i-nOldMots-1) / (SCENE.nmots-1);
            interpolated_color = ...
                c     * SCENE.colors.multipleSkels_FaceVertexData_end...
                + (1-c) * SCENE.colors.multipleSkels_FaceVertexData_start;
        end
        
        for j=1+SCENE.mots{i}.rotDataAvailable:SCENE.mots{i}.njoints
            nrOfNodes = size(SCENE.mots{i}.vertices{j},1)/3;
            v = reshape(SCENE.mots{i}.vertices{j}(:,1),3,nrOfNodes)';
            faces = SCENE.mots{i}.faces;
            
            if SCENE.nmots>1
                SCENE.mots{i}.joint_handles(j) = ...
                    patch('Vertices',v,'Faces',faces,...
                    'FaceColor',hsv2rgb(interpolated_color),...
                    'FaceAlpha',SCENE.colors.multipleSkels_FaceAlpha, ...
                    'EdgeColor',SCENE.colors.multipleSkels_EdgeColor);
                %% Small hack for dmg videos
%                 if i<3
%                     switch i
%                         case 1
%                             jmatx = [2,3,5,6,7];
%                             cl = [0 0.75 0.75];
%                             if(ismember(j, jmatx))
%                                 SCENE.mots{i}.joint_handles(j) = ...
%                                     patch('Vertices',v,'Faces',faces,...
%                                     'FaceColor',[0 0.75 0.75],'LineWidth',0.8,'Marker','o',...
%                                     'MarkerSize',4,...
%                                     'MarkerEdgeColor',cl,...
%                                     'MarkerFaceColor',cl,...
%                                     'FaceAlpha',1, ...
%                                     'EdgeColor',cl);
%                             else
%                                 SCENE.mots{i}.joint_handles(j) = ...
%                                     patch('Vertices',v,'Faces',faces,...
%                                     'FaceColor',[0 0.75 0.75],'LineWidth',1.2,...
%                                     'FaceAlpha',1, ...
%                                     'EdgeColor',cl);
%                             end
%                             % % %                                 SCENE.mots{i}.joint_handles(j) = ...
%                             % % %                                     patch('Vertices',v,'Faces',faces,...
%                             % % %                                     'FaceColor',[0 0.75 0.75],...
%                             % % %                                     'FaceAlpha',1, ...
%                             % % %                                     'EdgeColor',SCENE.colors.multipleSkels_EdgeColor);
%                         case 2
%                             SCENE.mots{i}.joint_handles(j) = ...
%                                 patch('Vertices',v,'Faces',faces,...
%                                 'FaceColor',[0.75 0 0.75],...
%                                 'FaceAlpha',1, ...
%                                 'EdgeColor',SCENE.colors.multipleSkels_EdgeColor);
%                     end
%                 else
%                     SCENE.mots{i}.joint_handles(j) = ...
%                         patch('Vertices',v,'Faces',faces,...
%                         'FaceColor',hsv2rgb(interpolated_color),...
%                         'FaceAlpha',SCENE.colors.multipleSkels_FaceAlpha, ...
%                         'EdgeColor',SCENE.colors.multipleSkels_EdgeColor);
%                 end
                %% end of hack ;-)
            else
                SCENE.mots{i}.joint_handles(j) = ...
                    patch('Vertices',v,'Faces',faces,...
                    'FaceVertexCData',SCENE.colors.singleSkel_FaceVertexData,...
                    'FaceColor',SCENE.colors.singleSkel_FaceColor,...
                    'FaceAlpha',SCENE.colors.singleSkel_FaceAlpha, ...
                    'EdgeColor',SCENE.colors.singleSkel_EdgeColor);
                
            end
            
        end
        SCENE.mots{i}.jointID_handles = -ones(SCENE.mots{i}.njoints,1);
        
        if SCENE.status.spread
            spreadVertices(i);
        end
        
    end
end

computeBoundingBoxSCENE();
axisDimensions = renewAxisDimensions(SCENE.boundingBox);
axis(axisDimensions);

if ishandle(SCENE.handles.curFrameLabel)
    set(SCENE.handles.curFrameLabel,'String',sprintf(' 1 / %d (%.2f s)', SCENE.nframes,0));
    if(SCENE.nframes > 1)
        
        a=get(SCENE.handles.control_Panel,'Children');
        for i=1:numel(a)-19
            delete(a(i));
        end
        set(SCENE.handles.sliderHandle,...
            'SliderStep',[1/SCENE.nframes (1/SCENE.size(1))*40],...
            'Max',SCENE.nframes);
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
end

if ishandle(SCENE.handles.fig)
    setFramePro(SCENE.status.curFrame);
end

if SCENE.samplingRate==0
    SCENE.samplingRate = 50;
end
end