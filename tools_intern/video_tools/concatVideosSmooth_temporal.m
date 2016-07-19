function concatVideosSmooth_temporal(infiles,outfile,im_intermediary,t_blend,varargin)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

if ~iscell(infiles)
    error('Expected cell array of AVI filenames as first argument!');
end

hold_frames = zeros(length(infiles),2);
if (nargin>4)
    hold_frames = varargin{1};
end

if (ischar(im_intermediary))
    im_intermediary = imread(im_intermediary);
elseif iscell(im_intermediary)
    for k=1:length(im_intermediary)
        if (ischar(im_intermediary{k}))
            im_intermediary{k} = imread(im_intermediary{k});
        end
    end
end

if (length(t_blend)==1)
    t_blend = t_blend*ones(1,length(infiles));
end
    
fileinfo = aviinfo(infiles{1});
h_first_mov = fileinfo.Height; 
w_first_mov = fileinfo.Width;

nframes_total = 0;
avi_out = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',fileinfo.FramesPerSecond);
strlen = 0;
for k=1:length(infiles)
    fileinfo = aviinfo(infiles{k});
  	h_mov = fileinfo.Height;
    w_mov = fileinfo.Width;
    disp(['File: ' infiles{k}, ', ' num2str(fileinfo.NumFrames) ' frames, each ' num2str(w_mov) 'x' num2str(h_mov) '.']);
  	if (w_first_mov~=w_mov || h_first_mov~=h_mov)
        error('All videos must have the same frame size as the first video!');
    end
    
    for j=1:fileinfo.NumFrames
        mov = aviread(infiles{k},j);
        if (j==1)
            num_reps = hold_frames(k,1);
        elseif (j==fileinfo.NumFrames)
            num_reps = hold_frames(k,2);
        else
            num_reps = 1;
        end
        for i=1:num_reps
            avi_out = addframe(avi_out,mov);
            nframes_total = nframes_total + 1;
            s = [num2str(nframes_total)];
            disp(char(8*ones(1,strlen+2)));
            strlen = length(s);
            disp(s);
        end
    end
    if (k<length(infiles))                       % compute transition by blending last frame of current movie 
        mov2 = aviread(infiles{k+1},1);          % to im_intermediary and from there to the first frame of the next movie
		if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
			mov2.cdata = flipdim(mov2.cdata,1);
			mov.cdata = flipdim(mov.cdata,1);
		end
        if (iscell(im_intermediary))
            if (isempty(im_intermediary{k}))
                M1 = blendImages(mov.cdata,mov2.cdata,'',fileinfo.FramesPerSecond,t_blend(k+1)*2);
                M2 = [];
            else
                M1 = blendImages(mov.cdata,im_intermediary{k},'',fileinfo.FramesPerSecond,t_blend(k+1));
                M2 = blendImages(im_intermediary{k},mov2.cdata,'',fileinfo.FramesPerSecond,t_blend(k+1));
            end
        else
            if (isempty(im_intermediary))
                M1 = blendImages(mov.cdata,mov2.cdata,'',fileinfo.FramesPerSecond,t_blend(k+1)*2);
                M2 = [];
            else
                M1 = blendImages(mov.cdata,im_intermediary,'',fileinfo.FramesPerSecond,t_blend(k+1));
                M2 = blendImages(im_intermediary,mov2.cdata,'',fileinfo.FramesPerSecond,t_blend(k+1));
            end
        end
        for j = 1:length(M1)
			if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
				M1(j).cdata = flipdim(M1(j).cdata,1);
			end
			avi_out = addframe(avi_out,M1(j));
            nframes_total = nframes_total + 1;
            s = [num2str(nframes_total)];
            disp(char(8*ones(1,strlen+2)));
            strlen = length(s);
            disp(s);
        end
        for j = 1:length(M2)
			if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
				M2(j).cdata = flipdim(M2(j).cdata,1);
			end
			avi_out = addframe(avi_out,M2(j));
            nframes_total = nframes_total + 1;
            s = [num2str(nframes_total)];
            disp(char(8*ones(1,strlen+2)));
            strlen = length(s);
            disp(s);
        end
    end
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes_total) ' frames.']);