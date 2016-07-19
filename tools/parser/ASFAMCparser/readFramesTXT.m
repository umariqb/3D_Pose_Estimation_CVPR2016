function [result,mot] = readFramesTXT(skel,mot,fid,range)

result = false;
%%%%%%%%%%%%%%%% read bone names and nDOFs
boneIndices = [];   % auxiliary array containing indices into skel.nodes in their sequence of appearance within the amc file
numDOF = [];        % auxiliary array containing the respective numbers of DOFs
lc = 0;             % line count
while (~feof(fid))
    pos = ftell(fid);
	token = fscanf(fid,'%s ',1); % read bone label
    fscanf(fid,'%d\n'); % read nDOF and newline
    lc = lc+1;
    if (~isnan(str2double(token))) % reached beginning of frame data!
        fseek(fid,pos,'bof');
        break;
    end
	boneIndex = strmatch(upper(token),upper(mot.boneNames),'exact');
	if (isempty(boneIndex))
        fclose(fid);
        error(['AMC: Unknown bone "' token '" in file: ' mot.filename '.TXT!']);
	end
	boneIndices = [boneIndices; boneIndex];
	
	ndof = size(skel.nodes(boneIndex).DOF,1);
	numDOF = [numDOF; ndof];    
end

fclose(fid);

data = textread([mot.filename '.TXT'],'','headerlines',lc)';
if max(abs(data(size(data,1),:))) == 0
    data = data(1:size(data,1)-1,:);
end
frame_num = size(data,2);

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
data = data(:,start_frame:end_frame);

dataIndex = 1;
for k = 1:length(boneIndices)
    boneIndex = boneIndices(k);
    nDOF = numDOF(k);
    if (boneIndex > 1) % not root
        mot.rotationEuler{boneIndex,1} = data(dataIndex:(dataIndex+nDOF-1),:);
        dataIndex = dataIndex + nDOF;
    else % root
        rot_vals = [];
        trans_vals = [];
        for m = 1:nDOF
            switch (lower(skel.nodes(1).DOF{m}(1)))
                case 'r' % rotation
                    rot_vals = [rot_vals; data(dataIndex,:)];
                case 't' % translation
                    trans_vals = [trans_vals; data(dataIndex,:)];                        
            end
            dataIndex = dataIndex + 1;
        end
        mot.rotationEuler{boneIndex,1} = rot_vals;
        mot.rootTranslation = trans_vals / skel.lengthUnit;
    end
end

result = true;