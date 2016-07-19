function sustainVideoFrames(infile,outfile,frames,sustain_length)
% sustainVideoFrames(infile,outfile,frames,sustain_length)

global VARS_GLOBAL_ANIM
if (isempty(who('VARS_GLOBAL_ANIM'))||isempty(VARS_GLOBAL_ANIM))
    VARS_GLOBAL_ANIM = emptyVarsGlobalAnimStruct;
end

if (length(frames) ~= length(sustain_length))
    error('Parameters frames and sustain_length must be vectors of the same length!');
end
frames = sort(frames);
fileinfo = aviinfo(infile);
nframes_in = fileinfo.NumFrames;
if (frames(end)>nframes_in)
    frames(end)=nframes_in;
    %error('Specified frames out of range!');
end

avi_out = avifile(outfile,'compression',VARS_GLOBAL_ANIM.video_compression,'quality',100,'fps',fileinfo.FramesPerSecond);
j = 1;
nframes_out = 0;
strlen = 0;
for k=1:nframes_in
    if (k == frames(j))
        L = sustain_length(j);
        if j < length(frames)
            j = j+1;
        end
    else
        L = 1;
    end
    if (L>0)
        mov = aviread(infile,k);
    end
    for (i = 1:L)
        avi_out = addframe(avi_out,mov);
        nframes_out = nframes_out+1;
        s = [num2str(nframes_out)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);
    end
end
avi_out = close(avi_out);
disp(['Wrote output video file ' outfile ', ' num2str(nframes_out) ' frames.']);