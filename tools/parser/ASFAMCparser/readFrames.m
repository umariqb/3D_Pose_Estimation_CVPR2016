function [result,mot] = readFrames(skel,mot,fid,range)

%%%%%%%%%% find :DEGREES section
found = false;
while ~found
    [result,lin]  = findNextASFSection(fid);
    if (~result)
        error(['AMC: Could not find DEGREES in ' mot.filename '!']);
    end

    [token,lin] = strtok(lin);
    token = token(2:end); % remove leading colon
    if strcmpi(token,'DEGREES')
        found = true;
    end
end

%%%%%%%%%%%% find out how many frames we are dealing with: seek to end and read backwards till last frame number
pos_degrees = ftell(fid);
found = false; % found last frame number
fseek(fid,-1,'eof'); % jump to end of file
while (ftell(fid) > 0 & ~found) % not at bof AND not found last frame number
    pos = ftell(fid);
    ch = fread(fid,1,'uchar'); % read current character
    if (ch == 10) % line feed
        l = fgetl(fid);
        fseek(fid,pos-1,'bof');
        if (l ~= -1) % no eof encountered
            [frame_num, OK] = str2num(l);
            if (OK)
                found = true;
            end
        end
    else
        fseek(fid,-2,'cof'); % jump 2 characters back
    end
end
if (~found)
   error(['AMC: Could not find last frame number in ' mot.filename '!']);
end
fseek(fid,pos_degrees,'bof');

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
    
mot.nframes = end_frame - start_frame + 1;

%%%%%%%%%%%%% read first frame and set up auxiliary index arrays for quicker access to data destinations
format_strings = {'%f\n'; '%f %f\n'; '%f %f %f\n'; '%f %f %f %f\n'; '%f %f %f %f %f\n'; '%f %f %f %f %f %f\n'; '%f %f %f %f %f %f %f\n'; '%f %f %f %f %f %f %f %f\n'; '%f %f %f %f %f %f %f %f %f\n'; '%f %f %f %f %f %f %f %f %f %f\n'};
boneIndices = []; % auxiliary array containing indices into skel.nodes in their sequence of appearance within the amc file
numDOF = []; % auxiliary array containing the respective numbers of DOFs

frame_num = fscanf(fid,'%f\n',1);
while (~feof(fid)) 
    pos = ftell(fid);
	token = fscanf(fid,'%s',1); % read bone label
    if (~isnan(str2double(token))) % reached beginning of next frame!!! rewind and exit loop!
        fseek(fid,pos,'bof');
        break;
    end
	boneIndex = strmatch(upper(token),upper(mot.boneNames),'exact');
	if (isempty(boneIndex))
        error(['AMC: Unknown bone "' token '" in file: ' mot.filename '!']);
	end
	boneIndices = [boneIndices; boneIndex];
	
	ndof = size(skel.nodes(boneIndex).DOF,1);
	numDOF = [numDOF; ndof];
    if (ndof < 1)
        continue;
    end
	
	new_vals = fscanf(fid,format_strings{ndof,1},ndof);
	
	if (boneIndex > 1) % not root
        mot.rotationEuler{boneIndex,1} = zeros(size(new_vals,1),mot.nframes);
        mot.rotationEuler{boneIndex,1}(:,1) = new_vals;
	else % root
        rot_vals = [];  
        trans_vals = [];
        for m = 1:ndof
            switch (lower(skel.nodes(1).DOF{m}(1)))
                case 'r' % rotation
                    rot_vals = [rot_vals; new_vals(m)];                        
                case 't' % translation
                    trans_vals = [trans_vals; new_vals(m)];                        
            end
        end
        mot.rotationEuler{boneIndex,1}= zeros(size(rot_vals,1),mot.nframes);
        mot.rotationEuler{boneIndex,1}(:,1) = rot_vals;
        mot.rootTranslation = zeros(size(trans_vals,1),mot.nframes);
        mot.rootTranslation = trans_vals / skel.lengthUnit;
	end
end

%%%%%%%%%% fast forward to start_frame
if (start_frame > 2)
	while ~feof(fid)
        pos = ftell(fid);
        frame_num = fscanf(fid,'%f\n',1);
	
        if (frame_num == start_frame)
            fseek(fid,pos,'bof');
            break;
        end

        for k = 1:length(boneIndices)
            lin = fgetl(fid);
        end
    end
end

%%%%%%%%%% now read the remaining frames with the aid of the auxiliary arrays
strlen = 0;
disp('Reading AMC frame number: ');
while (~feof(fid)) 
    frame_num = fscanf(fid,'%f\n',1);
    frame_num = frame_num - start_frame + 1;
    if (rem(frame_num,10)==0)
        s = [num2str(frame_num) '/' num2str(mot.nframes)];
        disp(char(8*ones(1,strlen+2)));
        strlen = length(s);
        disp(s);
    end
    for  k = 1:length(boneIndices)
        token = fscanf(fid,'%s',1); % read bone label
        boneIndex = boneIndices(k);
        
        ndof = numDOF(k);
        if (ndof < 1)
            continue;
        end

        new_vals = fscanf(fid,format_strings{ndof,1},ndof);
        
        if (boneIndex > 1) % not root
            mot.rotationEuler{boneIndex,1}(:,frame_num) = new_vals;
        else % root
            rot_vals = [];
            trans_vals = [];
            for m = 1:ndof
                switch (lower(skel.nodes(1).DOF{m}(1)))
                    case 'r' % rotation
                        rot_vals = [rot_vals; new_vals(m)];                        
                    case 't' % translation
                        trans_vals = [trans_vals; new_vals(m)];                        
                end
            end
            mot.rotationEuler{boneIndex,1}(:,frame_num) = rot_vals;
            mot.rootTranslation(:,frame_num) = trans_vals / skel.lengthUnit;
        end
    end
    if (frame_num + start_frame - 1 >= end_frame)
        break;
    end
end
s = [num2str(frame_num) '/' num2str(mot.nframes)];
disp(char(8*ones(1,strlen+2)));
disp(s);
