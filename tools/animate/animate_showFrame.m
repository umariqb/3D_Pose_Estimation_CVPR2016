function animate_showFrame(varargin)

global VARS_GLOBAL_ANIM

if (VARS_GLOBAL_ANIM.animation_done)
    return;
end

if (nargin>=1) % direct frame draw mode!
    tasks_executed = varargin{1};
    tasks_to_execute = inf;
else
	t = timerfind('Name','AnimationTimer');
	if (size(t)==0)
        return
	end
	t = t(1);
	tasks_executed = get(t,'TasksExecuted');
	tasks_to_execute = get(t,'TasksToExecute');
end

tic
%%%%%%%%%%%%% draw "current_frame" for all skeletons
for i = 1:length(VARS_GLOBAL_ANIM.skel)
    if (tasks_executed > length(VARS_GLOBAL_ANIM.range{i})) % if motion number i need not be animated anymore, skip it!
        continue;
    end
	current_frame = VARS_GLOBAL_ANIM.range{i}(tasks_executed);
	
	npaths = size(VARS_GLOBAL_ANIM.skel(i).paths,1);
	for k = 1:npaths
        path = VARS_GLOBAL_ANIM.skel(i).paths{k};
        nlines = length(path)-1;
        px = zeros(2,1); py = zeros(2,1); pz = zeros(2,1);
        px(1) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(1)}(1,current_frame); 
        py(1) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(1)}(2,current_frame); 
        pz(1) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(1)}(3,current_frame);
        for j = 2:nlines % path number
            px(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(j)}(1,current_frame); 
            py(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(j)}(2,current_frame); 
            pz(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(j)}(3,current_frame);
            set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).skel_lines{i}{k}(j-1),'XData',px,'YData',py,'ZData',pz);
            
            px(1) = px(2);
            py(1) = py(2);
            pz(1) = pz(2);
        end
        px(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(nlines+1)}(1,current_frame); 
        py(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(nlines+1)}(2,current_frame); 
        pz(2) = VARS_GLOBAL_ANIM.mot(i).jointTrajectories{path(nlines+1)}(3,current_frame);
        set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).skel_lines{i}{k}(nlines),'XData',px,'YData',py,'ZData',pz);
	end
	
    if (isfield(VARS_GLOBAL_ANIM.mot(i),'animated_patch_data'))
        npatches = length(VARS_GLOBAL_ANIM.mot(i).animated_patch_data);
        for k=1:npatches
            X = VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).X(:,current_frame);
            Y = VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).Y(:,current_frame);
            Z = VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).Z(:,current_frame);
            if (size(VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).color,1)==1)
                C = repmat(VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).color,size(Z,1),1);
            else
                C = repmat(VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).color(current_frame,:),size(Z,1),1);
            end

            switch (lower(VARS_GLOBAL_ANIM.mot(i).animated_patch_data(k).type))
                case 'disc'
                    set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).animated_patches{i}(k),...
                        'Vertices',[X Y Z],...
                        'FaceVertexCData',C);
                case 'polygondisc'
                    set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).animated_patches{i}(k),...
                        'Vertices',[X Y Z],...
                        'FaceVertexCData',C);
                case 'griddisc'
                    set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).animated_patches{i}(k),...
                        'Vertices',[X Y Z],...
                        'FaceVertexCData',C);
                case 'point'
                    if isempty(VARS_GLOBAL_ANIM.animated_point_MarkerEdgeColor)
                        markeredgecolor = C;
                    else
                        markeredgecolor = repmat(VARS_GLOBAL_ANIM.animated_point_MarkerEdgeColor,size(Z,1),1);
                    end
                    set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).animated_patches{i}(k),...
                        'Vertices',[X Y Z],...
                        'MarkerEdgeColor',markeredgecolor,...
                        'MarkerFaceColor',C);
                case 'cappedcylinder'
                    set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).animated_patches{i}(k),...
                        'Vertices',[X Y Z],...
                        'FaceVertexCData',C);
            end

        end
    end
    
    if (~isempty(VARS_GLOBAL_ANIM.draw_labels) && VARS_GLOBAL_ANIM.draw_labels(i))
    	set(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).text_handle(i),'string',sprintf('              Frame %d',current_frame),'position',VARS_GLOBAL_ANIM.mot(i).jointTrajectories{1}(:,current_frame));
    end
end
drawnow;

t = toc;

VARS_GLOBAL_ANIM.frames_drawn = VARS_GLOBAL_ANIM.frames_drawn + 1;
VARS_GLOBAL_ANIM.frame_draw_time = VARS_GLOBAL_ANIM.frame_draw_time + t;

if (tasks_executed>=tasks_to_execute)
    VARS_GLOBAL_ANIM.animation_done = true;
end
