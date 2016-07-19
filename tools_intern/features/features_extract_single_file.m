function varargout = features_extract_single_file(file_fullpath,features_spec,rle, constBoneLengths)
% [features,fs,tr,tf] = features_extract_single_file(file_fullpath,features_spec,rle, constBoneLengths)
% Extract features from a single file.
%
% file_fullpath.... full path to Mocap file or index into VARS_GLOBAL.files
% features_spec.... struct array specifying desired features
% rle ............. boolean switch specifying whether RLE is to be applied to the output; default: true
% constBoneLenghts. enforce constant bone lenghts after joint position estimation (just C3D); default: true
%
% returns a cell array of features, the file's sampling rate, and timing info for read-in (tr) and feature extraction (tf)

if (isnumeric(file_fullpath))
    global VARS_GLOBAL;
    file_fullpath = [VARS_GLOBAL.dir_root VARS_GLOBAL.D(file_fullpath).path_name VARS_GLOBAL.D(file_fullpath).file_name];
end

if (nargin < 3)
    rle = true;
end
if nargin < 4
    constBoneLengths = true;
end        

tr = cputime;
[info,OK] = filename2info(file_fullpath);
if (OK)
    switch (info.filetype)
        case 'BVH'
        [skel,mot] = readMocap(file_fullpath);
        case 'C3D'
%             if constBoneLengths
                [skel,mot] = readMocapLCS(file_fullpath, [], true);
%             else
%                 [skel,mot] = readMocapLCS(file_fullpath, [], true, 'none');
%             end
%         [skel,mot] = readMocap(file_fullpath);
        case 'ASF/AMC'
        [skel,mot] = readMocap([info.amcpath info.asfname], file_fullpath);
    end
elseif strcmpi(file_fullpath(end-3:end),'.bvh')
    [skel,mot] = readMocap(file_fullpath);
else % assume an AMC file with an ASF that has the same name
    [skel,mot] = readMocap([file_fullpath(1:end-4) '.asf'],file_fullpath);
end
tr = cputime - tr;

features_num = length(features_spec);
features = cell(features_num,1);
tf = cputime;
for j = 1:features_num
    h = str2func(features_spec(j).name);
    if (isempty(features_spec(j).params))
        if (rle)
            features{j} = runLengthEncode(feval(h, mot));
        else
            features{j} = feval(h, mot);
        end
    else
        if (rle)
            features{j} = runLengthEncode(feval(h, mot, features_spec(j).params{:}));
        else
            features{j} = feval(h, mot, features_spec(j).params{:});
        end
    end
end
tf = cputime - tf;

varargout{1} = features; 
if (nargout>1)
    varargout{2} = mot.samplingRate;
end
if (nargout>2)
    varargout{3} = tr;
end
if (nargout>3)
    varargout{4} = tf;
end
