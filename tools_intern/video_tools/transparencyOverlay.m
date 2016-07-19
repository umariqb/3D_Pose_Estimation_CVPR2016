function transparencyOverlay(infile, im, outfile, varargin)
% transparencyOverlay(infile, im, outfile, transparent, blend_func,fade_duration_in_sec)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

fade_duration_in_sec = 0.5;
if (nargin>5)
    fade_duration_in_sec = varargin{3};
end

if (ischar(im))
    im = imread(im);
end

fileinfo = aviinfo(infile);
h_im = size(im,1); h_mov = fileinfo.Height;
w_im = size(im,2); w_mov = fileinfo.Width;

if (w_im~=w_mov || h_im~=h_mov)
    error('Image and video frames must be of same size!');
end

transparent = [255 255 255];
frame_rate = fileinfo.FramesPerSecond;
nframes = fileinfo.NumFrames;
disp(['File: ' infile, ', ' num2str(nframes) ' frames, each ' num2str(w_mov) 'x' num2str(h_mov) '.']);
blend_func = [];
if (nargin>4)
    blend_func = varargin{2};
    if (~islogical(blend_func))
        if (length(blend_func)~=nframes)
            blend_func = resample(blend_func,nframes,length(blend_func));
        end
    end    
end
if (nargin>3)
    transparent = varargin{1};
end

fade_duration_in_frames = ceil(fade_duration_in_sec * frame_rate);
if (fade_duration_in_frames >= nframes)
    fade_duration_in_frames = 0;
end
if (isempty(blend_func))
    blend_func = [[0:fade_duration_in_frames-1]...
                  (fade_duration_in_frames-1)*ones(1,nframes-2*fade_duration_in_frames)...
                  [fade_duration_in_frames-1:-1:0]] / (fade_duration_in_frames-1);
end
if (islogical(blend_func))
    if (~blend_func(1) & ~blend_func(2))
        blend_func = ones(1,nframes);
    elseif (~blend_func(1) & blend_func(2))
        blend_func = [(fade_duration_in_frames-1)*ones(1,nframes-fade_duration_in_frames)...
                      [fade_duration_in_frames-1:-1:0]] / (fade_duration_in_frames-1);
    elseif (blend_func(1) & ~blend_func(2))
        blend_func = [[0:fade_duration_in_frames-1]...
                      (fade_duration_in_frames-1)*ones(1,nframes-fade_duration_in_frames)] / (fade_duration_in_frames-1);
    elseif (blend_func(1) & blend_func(2))
        blend_func = [[0:fade_duration_in_frames-1]...
                      (fade_duration_in_frames-1)*ones(1,nframes-2*fade_duration_in_frames)...
                      [fade_duration_in_frames-1:-1:0]] / (fade_duration_in_frames-1);
    end
end

transparent = transparent(3)+256*transparent(2)+256*256*transparent(1);

avi_out = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',frame_rate);
im = double(im);
% if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
%     im = flipdim(im,1);
% end
mask = im(:,:,3)+256*im(:,:,2)+256*256*im(:,:,1);
[I,J] = find(mask ~= transparent);
ind = sub2ind(size(mask),I,J);
mask = zeros(size(im,1),size(im,2));
mask(ind) = 1;
mask = repmat(mask,[1 1 3]);
strlen = 0;
for k = 1:nframes
    mov = aviread(infile,k);
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		mov.cdata = flipdim(mov.cdata,1);
	end
    alpha = blend_func(k);
    frame = uint8(floor(double(mov.cdata).*(1-mask*alpha) + im.*mask*alpha));
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		frame = flipdim(frame,1);
	end
    avi_out = addframe(avi_out,frame);
    s = [num2str(k) '/' num2str(nframes)];
    disp(char(8*ones(1,strlen+2)));
    strlen = length(s);
    disp(s);
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes) ' frames.']);
