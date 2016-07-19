function [result,mot,skel] = readMotion(mot,skel,fid,range,compute_quats)

tic
fseek(fid,0,'bof');
lc = 0;
[result,line,pos,line_count] = findKeyword(fid,'MOTION');
if ~result
    fclose(fid);
    error(['BVH section MOTION not found in file ' mot.filename '!']);
end
lc = lc + line_count;

[result,line,pos,line_count] = findKeyword(fid,'Frames:');
if ~result
    fclose(fid);
    error(['BVH section Frames not found in file ' mot.filename '!']);
end
line = deblank(line(8:size(line,2)));
frame_num = str2num(line);
lc = lc + line_count;

[result,line,pos,line_count] = findKeyword(fid,'Frame Time:');
if ~result
    fclose(fid);
    error(['BVH section Frame Time not found in file ' mot.filename '!']);
end
line = deblank(line(13:size(line,2)));
mot.frameTime = str2num(line);
mot.samplingRate = 1 / mot.frameTime;
lc = lc + line_count;

%%%%%%%%%%%%%%%% determine frame range to be read
if (length(range)<=0)
    start_frame = 1;
    end_frame = frame_num;
elseif (length(range)==1)
    start_frame = 1;
    end_frame = range(1);
else
    start_frame = range(1);
    end_frame = range(2);
end
if (start_frame > end_frame) % swap, if necessary
    h = end_frame;
    end_frame = start_frame;
    start_frame = h;
end
if (start_frame == -inf)
    start_frame = 1;
end
if (end_frame == inf)
    end_frame = frame_num;
end
if (end_frame > frame_num)
    error('end_frame greater than number of frames in file!');
end
    
fclose(fid);
mot.nframes = end_frame - start_frame + 1;
data = textread(mot.filename,'',mot.nframes,'headerlines',lc + start_frame - 1)';
if max(abs(data(size(data,1),:))) == 0
    data = data(1:size(data,1)-1,:);
end
t = toc;

disp(['Read ' num2str(mot.nframes) ' frames of motion data from ' mot.filename ' in ' num2str(t) ' seconds.']);

mot.rootTranslation = extractRootTranslation(skel,data);
%%%%%%%% extract and convert data
tic
[mot.rotationEuler, mot.rotationQuat] = extractRotation(skel, 1, data, 1, cell(mot.njoints,1), cell(mot.njoints,1), compute_quats);
t = toc;
if (compute_quats)
    disp(['Converted motion data from ' mot.filename ' in ' num2str(t) ' seconds.']);
end

mot.njoints = skel.njoints;
mot.jointNames = skel.jointNames;
mot.boneNames = skel.boneNames;
mot.animated = skel.animated;
mot.unanimated = skel.unanimated;

result = true;
