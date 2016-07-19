function animate(skel,mot,varargin)
% animate(skel,mot,num_repeats,time_stretch_factor,range,draw_labels)
% INPUT:  
%   - skel and mot are assumed to be struct arrays of identical length containing 
%     skeleton/motion pairs to be animated simultaneously. All mots are supposed to have the same samplingRate.
%   - range is a cell array which is supposed to be of same length as skel/mot. 
%     Empty cell array entries in range indicate that the entire frame range is to be played back.
%   - draw_labels is a logical vector the same length as skel indicating whether the corresponding skeleton 
%     is to be drawn with a frame counter label. Empty draw_labels means "draw no labels at all".

global VARS_GLOBAL_ANIM
if (isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

num_repeats = 1;
time_stretch_factor = 1;
VARS_GLOBAL_ANIM.range = cell(length(mot),1);
VARS_GLOBAL_ANIM.draw_labels = ones(length(mot),1);

if (nargin > 6)
    error('Too many arguments!');
end
if (nargin > 5)
    VARS_GLOBAL_ANIM.draw_labels = varargin{4};
end
if (nargin > 4)
    VARS_GLOBAL_ANIM.range = varargin{3};
    if (~iscell(VARS_GLOBAL_ANIM.range))
        VARS_GLOBAL_ANIM.range = {VARS_GLOBAL_ANIM.range};
    end
end
if (nargin > 3)
    time_stretch_factor = varargin{2};
end
if (nargin > 2)
    num_repeats = varargin{1};
end

VARS_GLOBAL_ANIM.skel = skel;
VARS_GLOBAL_ANIM.mot = mot;

num_frames = -inf;
for k=1:length(VARS_GLOBAL_ANIM.range)
    if (isempty(VARS_GLOBAL_ANIM.range{k}))
        VARS_GLOBAL_ANIM.range{k} = [1:VARS_GLOBAL_ANIM.mot(k).nframes];
    end
    if (length(VARS_GLOBAL_ANIM.range{k})>num_frames) % determine num_frames as maximum of range lengths
        num_frames = length(VARS_GLOBAL_ANIM.range{k});
    end
end

animate_initGraphics;

desired_frame_time = VARS_GLOBAL_ANIM.mot(1).frameTime;

% if (~isempty(VARS_GLOBAL_ANIM.figure_camera_file))
%     h = str2func(VARS_GLOBAL_ANIM.figure_camera_file);
%     feval(h, gca);
% end

if (~isempty(VARS_GLOBAL_ANIM.figure_position))
    set(gcf,'position',VARS_GLOBAL_ANIM.figure_position);
end
for (i=1:num_repeats)
    VARS_GLOBAL_ANIM.frame_draw_time = 0;
    VARS_GLOBAL_ANIM.frames_drawn = 0;
    VARS_GLOBAL_ANIM.animation_done = false;
    t=timerfind('Name','AnimationTimer');
    if (~isempty(t))
        delete(t);
    end
	t = timer('Name','AnimationTimer');
    try
        set(t,'TimerFcn','animate_showFrame');
        set(t,'ExecutionMode','fixedRate');
		set(t,'TasksToExecute',num_frames);
        period = round(1000*desired_frame_time/time_stretch_factor)/1000;
        if (period == 0)
            warning(['Requested timer period of ' num2str(desired_frame_time/time_stretch_factor) ' s is too short for Matlab! Setting period to minimum of 1 ms :-(']);
            period = 0.001;
        end
		set(t,'Period',period);
		set(t,'BusyMode','queue');
        t1=clock;
		start(t);
		wait(t);
        t2=clock;
        elapsed_time = etime(t2,t1);
		delete(t);
    catch
		delete(t);
        return
    end
    clip_duration = desired_frame_time*num_frames/time_stretch_factor;
    avg_frame_time = elapsed_time / VARS_GLOBAL_ANIM.frames_drawn;
    VARS_GLOBAL_ANIM.frames_drawn;
    actual_frame_rate = 1/avg_frame_time;
    target_frame_rate = time_stretch_factor/desired_frame_time;
    disp(['Frame rate: ' num2str(actual_frame_rate) ' fps, target frame rate was ' num2str(target_frame_rate) ' fps.']);
    disp(['Clip duration: ' num2str(clip_duration) ' sec. Total frame drawing time: ' num2str(VARS_GLOBAL_ANIM.frame_draw_time) ' sec, ' num2str(100*(target_frame_rate/actual_frame_rate)*VARS_GLOBAL_ANIM.frame_draw_time/clip_duration) ' percent load.']);
end
