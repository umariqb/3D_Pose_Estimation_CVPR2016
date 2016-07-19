function reverseVideo(infile,outfile)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

fileinfo = aviinfo(infile);
h_first_mov = fileinfo.Height; 
w_first_mov = fileinfo.Width;

nframes_total = 0;
avi_out = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',fileinfo.FramesPerSecond);
fileinfo = aviinfo(infile);
h_mov = fileinfo.Height;
w_mov = fileinfo.Width;
disp(['File: ' infile, ', ' num2str(fileinfo.NumFrames) ' frames, each ' num2str(w_mov) 'x' num2str(h_mov) '.']);

strlen = 0;
for j=fileinfo.NumFrames:-1:1
    mov = aviread(infile,j);
	avi_out = addframe(avi_out,mov);
    nframes_total = nframes_total + 1;
    s = [num2str(nframes_total)];
    disp(char(8*ones(1,strlen+2)));
    strlen = length(s);
    disp(s);
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes_total) ' frames.']);