function animateVideo(skel,mot,videofile,varargin)
% animateVideo(skel,mot,videofile,num_repeats,time_stretch_factor,downsampling_fac,range,draw_labels,fps)
% INPUT:  
%   - skel and mot are assumed to be struct arrays of identical length containing 
%     skeleton/motion pairs to be animated simultaneously. All mots are supposed to have the same samplingRate.
%   - range is a cell array which is supposed to be of same length as skel/mot. 
%     Empty cell array entries in range indicate that the entire frame range is to be played back.
%   - downsampling_fac is an integer indicating the desired downsampling factor.
%   - draw_labels is a logical vector the same length as skel indicating whether the corresponding skeleton 
%     is to be drawn with a frame counter label
%   - fps, frames per second, overrides the default sampling rate taken from the mot datastructure
%   - videofile is the filename of the output AVI.

global VARS_GLOBAL_ANIM
if (isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

fps = [];
num_repeats = 1;
time_stretch_factor = 1;
downsampling_fac = 1;
hold_frames = [];
VARS_GLOBAL_ANIM.range = cell(length(mot),1);
VARS_GLOBAL_ANIM.draw_labels = ones(length(mot),1);
str = '';

if (nargin > 11)
    error('Too many arguments!');
end
if (nargin > 10)
    str = varargin{8};
end
if (nargin > 9)
    hold_frames = varargin{7};
end
if (nargin > 8)
    fps = varargin{6};
end
if (nargin > 7)
    VARS_GLOBAL_ANIM.draw_labels = varargin{5};
end
if (nargin > 6)
    VARS_GLOBAL_ANIM.range = varargin{4};
    if (~iscell(VARS_GLOBAL_ANIM.range))
        VARS_GLOBAL_ANIM.range = {VARS_GLOBAL_ANIM.range};
    end
end
if (nargin > 5)
    downsampling_fac = varargin{3};
end
if (nargin > 4)
    time_stretch_factor = varargin{2};
end
if (nargin > 3)
    num_repeats = varargin{1};
end

VARS_GLOBAL_ANIM.skel = skel;
VARS_GLOBAL_ANIM.mot = mot;

num_frames = -inf;
for k=1:length(VARS_GLOBAL_ANIM.range)
    if (isempty(VARS_GLOBAL_ANIM.range{k}))
        VARS_GLOBAL_ANIM.range{k} = [1:VARS_GLOBAL_ANIM.mot(k).nframes];
    end
    if (downsampling_fac > 1)
        VARS_GLOBAL_ANIM.range{k} = intersect(VARS_GLOBAL_ANIM.range{k},[1:downsampling_fac:VARS_GLOBAL_ANIM.mot(k).nframes]);
    end
    if (length(VARS_GLOBAL_ANIM.range{k})>num_frames) % determine num_frames as maximum of range lengths
        num_frames = length(VARS_GLOBAL_ANIM.range{k});
    end
end
if (isempty(hold_frames))
    hold_frames = ones(1,num_frames);
end

animate_initGraphics;

figure(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).figure);

if (~isempty(VARS_GLOBAL_ANIM.figure_camera_file))
    h = str2func(VARS_GLOBAL_ANIM.figure_camera_file);
    feval(h, gca);
else
    set(gca,'CameraViewAngle',5);
end

desired_frame_time = VARS_GLOBAL_ANIM.mot(1).frameTime*downsampling_fac;

if (isempty(fps))
    fps = ceil(VARS_GLOBAL_ANIM.mot(1).samplingRate/downsampling_fac);
end
aviobj = avifile(videofile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',75,'fps',fps);
%set(gcf,'units','centimeters');
%set(gcf,'paperunits','centimeters');
%set(gcf,'paperposition',get(gcf,'position'));
%set(gcf,'units','pixels');
%set(gca,'units','pixels');
if (~isempty(VARS_GLOBAL_ANIM.figure_position))
    set(gcf,'position',VARS_GLOBAL_ANIM.figure_position);
end

%h = get(gca,'children');
%set(h([32:34]),'marker','none');

%axes_rect = round(get(gca,'position'));
%        frame = hardcopy(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).figure, '-dzbuffer', ['-r' num2str(round(get(0,'screenp')))]);
%        fy = size(frame,1); 
%        ayl = fy-axes_rect(2)-axes_rect(4)+1; ayh = fy-axes_rect(2); axl = axes_rect(1)+1; axh = axes_rect(1)+axes_rect(3);
%set(gca,'units','normalized');

h=axes('units','normalized','position',[0 0 1 1],'visible','off');
set(h,'units','pixels');
text(10,460,str,'fontsize',12,'fontweight','bold','color','b');

for (i=1:num_repeats)
    VARS_GLOBAL_ANIM.frame_draw_time = 0;
    VARS_GLOBAL_ANIM.frames_drawn = 0;
    VARS_GLOBAL_ANIM.animation_done = false;
    
    strlen = 0;
    count = 0;
    for k = 1:num_frames
        for j=1:hold_frames(k)
            animate_showFrame(k);
            %        frame = getframe(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).figure,[axl ayl axh-axl+1 ayh-ayl+1]);
            %        frame = frame(ayl:ayh,axl:axh,:);
            frame = getframe(VARS_GLOBAL_ANIM.graphics_data(VARS_GLOBAL_ANIM.graphics_data_index).figure);
            
            if (VARS_GLOBAL_ANIM.video_flip_vert) % strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1') | 
                frame.cdata = flipdim(frame.cdata,1);
            end
            if (VARS_GLOBAL_ANIM.video_flip_horz)
                frame.cdata = flipdim(frame.cdata,2);
            end
            
            aviobj = addframe(aviobj,frame);
            count = count+1;
            s = [num2str(count) '/' num2str(sum(hold_frames))];
            disp(char(8*ones(1,strlen+2)));
            strlen = length(s);
            disp(s);
        end
    end
    
    clip_duration = desired_frame_time*num_frames/time_stretch_factor;
    avg_frame_time = VARS_GLOBAL_ANIM.frame_draw_time / VARS_GLOBAL_ANIM.frames_drawn;
    actual_frame_rate = 1/avg_frame_time;
    target_frame_rate = time_stretch_factor/desired_frame_time;
    disp(['Frame rate: ' num2str(actual_frame_rate) ' fps, target frame rate was ' num2str(target_frame_rate) ' fps.']);
    disp(['Clip duration: ' num2str(clip_duration) ' sec. Total frame drawing time: ' num2str(VARS_GLOBAL_ANIM.frame_draw_time) ' sec, ' num2str(100*(target_frame_rate/actual_frame_rate)*VARS_GLOBAL_ANIM.frame_draw_time/clip_duration) ' percent load.']);
end
aviobj = close(aviobj);
disp(['Wrote output video file ' videofile '.']);