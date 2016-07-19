function varargout = extractVideoFrame(infile,framenum,varargin)
% im = extractVideoFrame(infile,outfile)

outfile = '';
if (nargin>2)
    outfile = varargin{1};
end

if (nargout==0 & isempty(outfile))
    error('Expected either a filename as second argument or a left-hand-side variable!');
end

inf = aviinfo(infile);

if (ischar(framenum))
    if (strcmpi(framenum,'first'))
        framenum = 1;        
    elseif (strcmpi(framenum,'last'))
        framenum = inf.NumFrames;
    else
        error('Illegal frame specification!');
    end
end

mov = aviread(infile,framenum);
if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
	mov.cdata = flipdim(mov.cdata,1);
end
if (nargout==0)
    imwrite(mov.cdata,outfile,'tiff','compression','packbits');
else
    varargout{1} = mov.cdata;
end
