function padVideo(infile,outfile,padding,padlength,varargin)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end


padpos = 'b'; % either tOP, bOTTOM, lEFT, or rIGHT
if (nargin>4)
    padpos = varargin{1};
end

fileinfo = aviinfo(infile);
nframes = fileinfo.NumFrames;
w = fileinfo.Width;
h = fileinfo.Height;

if (ischar(padding))
    im = imread(padding);
    switch (padpos)
        case 't'
            im = im(1:padlength,:,:);
        case 'b'
            im = im(1:padlength,:,:);
        case 'l'
            im = im(:,1:padlength,:);
        case 'r'
            im = im(:,1:padlength,:);
        otherwise
            error('Padding position has to be t, b, l or r!');
    end
else
    switch (padpos)
        case 't'
            im = uint8(shiftdim(repmat(padding',[1 padlength w]),1));
        case 'b'
            im = uint8(shiftdim(repmat(padding',[1 padlength w]),1));
        case 'l'
            im = uint8(shiftdim(repmat(padding',[1 h padlength]),1));
        case 'r'
            im = uint8(shiftdim(repmat(padding',[1 h padlength]),1));
        otherwise
            error('Padding position has to be t, b, l or r!');
    end
end

aviobj = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',fileinfo.FramesPerSecond);
strlen = 0;
for k = 1:nframes
    mov = aviread(infile,k);
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		mov.cdata = flipdim(mov.cdata,1);
	end
    switch (padpos)
        case 't'
            frame = cat(1,im,mov.cdata);
        case 'b'
            frame = cat(1,mov.cdata,im);
        case 'l'
            frame = cat(2,im,mov.cdata);
        case 'r'
            frame = cat(2,mov.cdata,im);
        otherwise
            error('Padding position has to be t, b, l or r!');
    end
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		frame = flipdim(frame,1);
	end
    aviobj = addframe(aviobj,frame);
    s = [num2str(k) '/' num2str(nframes)];
    disp(char(8*ones(1,strlen+2)));
    strlen = length(s);
    disp(s);
end
aviobj = close(aviobj);
disp(['Wrote output video file ' outfile '.']);