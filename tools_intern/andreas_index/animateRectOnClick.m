function    animateRectOnClick(src,eventdata,filename,varargin)

global VARS_GLOBAL
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

frame_start = [];
frame_end = [];
cost = [];
if (nargin>6)
    feature_set = varargin{4};
end
if (nargin>5)
    cost = varargin{3};
end
if (nargin>4)
    frame_end = varargin{2};
end
if (nargin>3)
    frame_start = varargin{1};
end


t = get(gcf,'selectionType');
switch t
%%%%%%%%%% left click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'normal'
    if (isfield(VARS_GLOBAL_ANIM,'figure_popup'))
        if (ishandle(VARS_GLOBAL_ANIM.figure_popup) && strcmp(get(VARS_GLOBAL_ANIM.figure_popup,'UserData'),'popup') )
            h = VARS_GLOBAL_ANIM.figure_popup;
            figure(h);
        else
            VARS_GLOBAL_ANIM.figure_popup = figure;
            set(gcf,'userdata','popup');
        end
    else
        VARS_GLOBAL_ANIM.figure_popup = figure;
        set(gcf,'userdata','popup');
    end
    
    amcfullpath = fullfile(VARS_GLOBAL.dir_root, filename);
    [info,OK] = filename2info(amcfullpath);
    [skel,mot] = readMocap([info.amcpath filesep info.asfname],amcfullpath);
    if (~isempty(frame_start) && ~isempty(frame_end))
        mot = cropMot(mot,[frame_start:frame_end]);
    end
    
    set(gcf,'name',[info.skeletonSource ' ' info.skeletonID ' ' info.motionCategory ' ' info.motionDescription ' cost: ' num2str(cost, '%1.3f')]);
    
    animate(skel,mot,1,1,1:mot.nframes,1 );
    
%%%%%%%%%% right click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'alt'
    
%%%%%%%%%% shift click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'extend'

end
