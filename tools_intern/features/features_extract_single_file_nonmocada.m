function varargout = features_extract_single_file_nonmocada(skelfile_fullpath,motfile_fullpath,features_spec,varargin)
% [features,fs,tr,tf] = features_extract_single_file_nonmocada(skelfile_fullpath,motfile_fullpath,features_spec,rle)
% Extract features from a single file.
%
% file_fullpath.... full path to Mocap file or index into VARS_GLOBAL.files
% features_spec.... struct array specifying desired features
% rle ............. boolean switch specifying whether RLE is to be applied to the output; default: true
%
% returns a cell array of features, the file's sampling rate, and timing info for read-in (tr) and feature extraction (tf)

if (isnumeric(skelfile_fullpath))
    global VARS_GLOBAL;
    skelfile_fullpath = [VARS_GLOBAL.dir_root VARS_GLOBAL.D(file_fullpath).path_name VARS_GLOBAL.D(file_fullpath).file_name];
end

rle = true;
if (nargin>3)
    rle = varargin{1};
end

if (ischar(skelfile_fullpath)) % filenames?
    tr = cputime;
    if strcmpi(skelfile_fullpath(end-3:end),'.bvh')
        [skel,mot] = readMocap(skelfile_fullpath);
    else 
        [skel,mot] = readMocap(skelfile_fullpath,motfile_fullpath);
    end
    tr = cputime - tr;
else % pre-loaded structs.
    skel = skelfile_fullpath;
    mot = motfile_fullpath;
end

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
