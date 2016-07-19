function concatVideos_temporal(infiles,outfile)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

if ~iscell(infiles)
    error('Expected cell array of AVI filenames as first argument!');
end

fileinfo = aviinfo(infiles{1});
h_first_mov = fileinfo.Height; 
w_first_mov = fileinfo.Width;

nframes_total = 0;
avi_out = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',fileinfo.FramesPerSecond);
for k=1:length(infiles)
    fileinfo = aviinfo(infiles{k});
  	h_mov = fileinfo.Height;
    w_mov = fileinfo.Width;
    disp(['File: ' infiles{k}, ', ' num2str(fileinfo.NumFrames) ' frames, each ' num2str(w_mov) 'x' num2str(h_mov) '.']);
  	if (w_first_mov~=w_mov || h_first_mov~=h_mov)
        error('All videos must have the same frame size as the first video!');
    end
    
    strlen = 0;
    for j=1:fileinfo.NumFrames
        mov = aviread(infiles{k},j);
        avi_out = addframe(avi_out,mov.cdata);
        nframes_total = nframes_total + 1;
        s = [num2str(nframes_total)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);
    end
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes_total) ' frames.']);