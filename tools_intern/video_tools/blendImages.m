function varargout = blendImages(im1, im2, outfile, varargin)
% blendImages(im1, im2, outfile, frame_rate, blend_func)
% OR blendImages(im1, im2, outfile, frame_rate, blend_length_in_sec)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

if (ischar(im1))
    im1 = imread(im1);
end
if (ischar(im2))
    im2 = imread(im2);
end

blend_length_in_sec = 1;
frame_rate = 30;
nframes = 1;
blend_func = [];
if (nargin>4)
    if (length(varargin{1})==1)
        blend_length_in_sec = varargin{2};
    else
        blend_func = varargin{2};
        blend_length_in_sec = nframes/frame_rate;
    end
end
if (nargin>3)
    frame_rate = varargin{1};
end

if (isempty(blend_func))
    nframes = ceil(blend_length_in_sec * frame_rate);
    blend_func = [0;cumsum((1/(nframes-1))*ones(nframes-1,1))];
end

h1 = size(im1,1); h2 = size(im2,1);
w1 = size(im1,2); w2 = size(im2,2);

if (w1~=w2 || h1~=h2)
    error('Images have to be of same size!');
end

if (nargout == 0) % create video
	aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',frame_rate);
	for k = 1:nframes
        alpha = blend_func(k);
        frame = uint8(floor((1-alpha)*double(im1) + alpha*double(im2)));
		if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
			frame.cdata = flipdim(frame.cdata,1);
		end
        aviobj = addframe(aviobj,frame);
	end
	aviobj = close(aviobj);
	disp(['Wrote output video file ' outfile '.']);
else % create movie struct
    if (nframes==0)
        M = [];
    else
        for k = 1:nframes
            alpha = blend_func(k);
            M(k).cdata = uint8(floor((1-alpha)*double(im1) + alpha*double(im2)));
            M(k).colormap = [];
    	end
    end
    varargout{1} = M;
end
