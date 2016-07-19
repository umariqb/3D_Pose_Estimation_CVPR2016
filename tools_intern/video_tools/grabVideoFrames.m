function grabVideoFrames(figure,num_frames,videofile,varargin)
global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

open_avi = true;
close_avi = true;
if (nargin>4)
    close_avi = varargin{2};
end
if (nargin>3)
    open_avi = varargin{1};
end

if (open_avi)
    VARS_GLOBAL_ANIM.aviobj = avifile(videofile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',30);
end

num_frames = ceil(num_frames);
for k=1:num_frames
    frame = getframe(figure);
    VARS_GLOBAL_ANIM.aviobj = addframe(VARS_GLOBAL_ANIM.aviobj,frame);
end

if (close_avi)
    VARS_GLOBAL_ANIM.aviobj = close(VARS_GLOBAL_ANIM.aviobj);
    disp(['Wrote output video file ' videofile '.']);    
end
