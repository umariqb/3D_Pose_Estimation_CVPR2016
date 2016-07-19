function concatVideos_spatial(infiles,outfile,varargin)
% concatVideos_spatial(infiles,outfile,dir)
% dir can be either 'h' or 'v' for horizontal/vertical concatenation

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

dir = 'h';
if (nargin>2)
    dir = varargin{1};
end
    
if ~iscell(infiles)
    error('Expected cell array of AVI filenames as first argument!');
end

h_total = 0;
w_total = 0;
h_mov = zeros(1,length(infiles));
w_mov = zeros(1,length(infiles));
for k=1:length(infiles)
    fileinfo = aviinfo(infiles{k});
    if (k==1)
        h_first_mov = fileinfo.Height; 
        w_first_mov = fileinfo.Width;
        nframes_first_mov = fileinfo.NumFrames;
    end
    if (fileinfo.NumFrames < nframes_first_mov)
       error('All videos must have at least as many frames as the first video!');
    end
    h_mov(k) = fileinfo.Height;
    w_mov(k) = fileinfo.Width;
    switch (dir)
        case 'h'
  	        if (h_first_mov~=h_mov)
                error('All videos must have the same frame height as the first video in horizontal concatenation mode!');
            end
        case 'v'
          	if (w_first_mov~=w_mov)
                error('All videos must have the same frame width as the first video in vertical concatenation mode!');
            end
        otherwise
            error('Dir has to be either h or v!');
    end
    h_total = h_total + h_mov(k);    
    w_total = w_total + w_mov(k);
end

avi_out = avifile(outfile,'compression','none','quality',100,'fps',fileinfo.FramesPerSecond);
strlen = 0;

movs = cell(1,length(infiles));

for k=1:length(infiles)
   movs{1,k} = mmreader(infiles{k});
end

for j=1:nframes_first_mov
    switch (dir)
        case 'h'
            frame = uint8(zeros(h_first_mov,w_total,3));
            x = 1;
            for k=1:length(infiles)
                if (j==1)
                    disp(['File: ' infiles{k}, ', ' num2str(w_mov(k)) 'x' num2str(h_mov(k)) '.']);
                end
%                 mov2 = aviread(infiles{k},j);
%                 movobj = mmreader(infiles{k});
                mov.cdata = read(movs{1,k},j);
                
				if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
					mov.cdata = flipdim(mov.cdata,1);
				end
                frame(:,[x:x+w_mov(k)-1],:) = mov.cdata;
                x = x + w_mov(k);
            end
        case 'v'
            frame = uint8(zeros(h_total,w_first_mov,3));
            y = 1;
            for k=1:length(infiles)
                if (j==1)
                    disp(['File: ' infiles{k}, ', ' num2str(w_mov(k)) 'x' num2str(h_mov(k)) '.']);
                end
%                 mov = aviread(infiles{k},j);
%                 movobj = mmreader(infiles{k});
                mov.cdata = read(movs{1,k},j);
				if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
					mov.cdata = flipdim(mov.cdata,1);
				end
                frame([y:y+h_mov(k)-1],:,:) = mov.cdata;
                y = y + h_mov(k);
            end
        otherwise
            error('Dir has to be either h or v!');
    end
	if (strcmpi(VARS_GLOBAL_ANIM.video_compression,'PNG1'))
		frame = flipdim(frame,1);
	end
    avi_out = addframe(avi_out,frame);
    s = [num2str(j) '/' num2str(nframes_first_mov)];
    disp(char(8*ones(1,strlen+2)));
    strlen = length(s);
    disp(s);
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes_first_mov) ' frames.']);