function animateOnClickSegments(src,eventdata,filename,varargin)

global VARS_GLOBAL
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

frame_start_all = [];
frame_end_all = [];
frame_start = [];
frame_end = [];
feature_set = '';
feature_set_ranges = [];
if (nargin>8)
    feature_set_ranges = varargin{6};
end
if (nargin>7)
    feature_set = varargin{5};
end
if (nargin>6)
    frame_end_all = varargin{4};
end
if (nargin>5)
    frame_start_all = varargin{3};
end
if (nargin>4)
    frame_end = varargin{2};
end
if (nargin>3)
    frame_start = varargin{1};
end

if (iscell(feature_set))
    f = '';
    for k=1:length(feature_set)
        f = [f '_' feature_set{k}];
    end
    feature_set_name = f;
else
    feature_set_name = feature_set;
    feature_set = {feature_set};
end
if (~iscell(feature_set_ranges))
    feature_set_ranges = {feature_set_ranges};
end
DB_name = ['DB_segments_' feature_set_name];
if (isfield(VARS_GLOBAL,DB_name))
   DB = getfield(VARS_GLOBAL,DB_name);
else
   DB = {};
end

t = get(gcf,'selectionType');
switch t
%%%%%%%%%% left click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'normal'
    if (isfield(VARS_GLOBAL_ANIM,'figure_popup'))
        if (ishandle(VARS_GLOBAL_ANIM.figure_popup) & strcmp(get(VARS_GLOBAL_ANIM.figure_popup,'UserData'),'popup') )
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
    
    amcfullpath = [VARS_GLOBAL.dir_root filesep filename];
    [info,OK] = filename2info(amcfullpath);
    [skel,mot] = readMocap([info.amcpath filesep info.asfname],amcfullpath);
    if (~isempty(frame_start) & ~isempty(frame_end))
        mot = cropMot(mot,[frame_start:frame_end]);
    end
    
    set(gcf,'name',[info.skeletonSource ' ' info.skeletonID ' ' info.motionCategory ' ' info.motionDescription]);
    
    animate(skel,mot);
    
%%%%%%%%%% right click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'alt'
    if (isempty(DB))
        return;
    end
    if (isfield(VARS_GLOBAL_ANIM,'figure_popup2'))
        if (ishandle(VARS_GLOBAL_ANIM.figure_popup2) & strcmp(get(VARS_GLOBAL_ANIM.figure_popup2,'UserData'),'popup2') )
            h = VARS_GLOBAL_ANIM.figure_popup2;
            figure(h);
        else
            VARS_GLOBAL_ANIM.figure_popup2 = figure;
            set(gcf,'userdata','popup2');
        end
    else
        VARS_GLOBAL_ANIM.figure_popup2 = figure;
        set(gcf,'userdata','popup2');
    end
    
    amcfullpath = [VARS_GLOBAL.dir_root filesep filename];
    [info,OK] = filename2info(amcfullpath);
    I = strmatch(filename,DB.files_name);
    if (isempty(I))
        warning(['Unknown file "' filename '"!']);
        return;
    end
%     features = DB.features(:,DB.files_frame_start(I):DB.files_frame_end(I));
%     if (isfinite(frame_start) & isfinite(frame_end))
%         features = features(:,floor((frame_start+(downsampling_fac-1))/downsampling_fac):floor((frame_end+(downsampling_fac-1))/downsampling_fac));
%     end
    if (~isempty(frame_start_all) & ~isempty(frame_end_all))
        features = DB.features(:,frame_start_all:frame_end_all);
    else
        features = DB.features(:,DB.files_frame_start(I):DB.files_frame_end(I));
    end
    
    num_ranges = length(feature_set_ranges);
    for k=1:num_ranges
        subplot(num_ranges,1,k); imagesc(features(feature_set_ranges{k},:),[0 1]); colormap gray;
        if (k==1)
            if (~isempty(frame_start_all) & ~isempty(frame_end_all))
                title([' DB frames ' num2str(frame_start_all) '-' num2str(frame_end_all) ' / MoCap file frames ' num2str(frame_start) '-' num2str(frame_end)]);
            elseif (~isempty(frame_start) & ~isempty(frame_end))
                title([' DB frames ' num2str(frame_start) '-' num2str(frame_end)]);
            end
        end
        h = ylabel(feature_set{k});
        set(h,'interpreter','none');
    end
    set(gcf,'name',['Features ' feature_set_name ' for ' info.skeletonSource ' ' info.skeletonID ' ' info.motionCategory ' ' info.motionDescription]);
%%%%%%%%%% shift click %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'extend'
    if (isempty(DB))
        return;
    end
    VARS_GLOBAL_ANIM.figure_popup2 = figure;
    set(gcf,'userdata','popup2');
    
    amcfullpath = [VARS_GLOBAL.dir_root filesep filename];
    [info,OK] = filename2info(amcfullpath);
    I = strmatch(filename,DB.files_name);
    if (isempty(I))
        warning(['Unknown file "' filename '"!']);
        return;
    end
%     features = DB.features(:,DB.files_frame_start(I):DB.files_frame_end(I));
%     if (isfinite(frame_start) & isfinite(frame_end))
%         features = features(:,floor((frame_start+(downsampling_fac-1))/downsampling_fac):floor((frame_end+(downsampling_fac-1))/downsampling_fac));
%     end
    if (~isempty(frame_start_all) & ~isempty(frame_end_all))
        features = DB.features(:,frame_start_all:frame_end_all);
    else
        features = DB.features(:,DB.files_frame_start(I):DB.files_frame_end(I));
    end
    
    num_ranges = length(feature_set_ranges);
    for k=1:num_ranges
        subplot(num_ranges,1,k); imagesc(features(feature_set_ranges{k},:),[0 1]); colormap gray;
        if (k==1)
            if (~isempty(frame_start_all) & ~isempty(frame_end_all))
                title([' DB frames ' num2str(frame_start_all) '-' num2str(frame_end_all) ' / MoCap file frames ' num2str(frame_start) '-' num2str(frame_end)]);
            elseif (~isempty(frame_start) & ~isempty(frame_end))
                title([' DB frames ' num2str(frame_start) '-' num2str(frame_end)]);
            end
        end
        h = ylabel(feature_set{k});
        set(h,'interpreter','none');
    end
    set(gcf,'name',['Features ' feature_set_name ' for ' info.skeletonSource ' ' info.skeletonID ' ' info.motionCategory ' ' info.motionDescription]);
end
