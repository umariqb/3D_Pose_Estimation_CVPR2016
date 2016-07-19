function replicateImage(im, outfile, varargin)
% replicateImage(im, outfile, frame_rate, duration_in_sec)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

if (ischar(im))
    im = imread(im);
end

duration_in_sec = 1;
frame_rate = 30;
nframes = 30;
if (nargin>3)
    duration_in_sec = varargin{2};
end
if (nargin>2)
    frame_rate = varargin{1};
end

nframes = ceil(frame_rate * duration_in_sec);

%if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
%	im = flipdim(im,1);
%end
aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',frame_rate);
strlen = 0;
for k = 1:nframes
    aviobj = addframe(aviobj,im);
    s = [num2str(k) '/' num2str(nframes)];
    disp(char(8*ones(1,strlen+2)));
    strlen = length(s);
    disp(s);
end
aviobj = close(aviobj);
disp(['Wrote output video file ' outfile '.']);