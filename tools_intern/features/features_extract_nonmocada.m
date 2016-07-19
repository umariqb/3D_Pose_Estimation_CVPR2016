function varargout = features_extract_nonmocada(files, features_spec, varargin)
% varargout = features_extract_nonmocada(files, features_spec, outfile, dir_root, rle)
% 
% Extracts and RLE-compresses specified boolean features from a given set of MoCap
% files and, if desired, saves the features to a file.
% 
% files.......... file names relative to dir_root
% features_spec.. struct array of feature specifications
% outfile ....... if specified, name of mat file to save results to; default: empty
% dir_root ...... path prefix for file names; default:  VARS_GLOBAL.dir_root
% rle............ boolean flag indicating whether run length encoding is to be applied; default: true
% 
% opt. returns .. [F, t_read, t_feature] (timing info for read-in (t_read) and feature extraction (t_feature))

global VARS_GLOBAL;

outfile = '';
dir_root = VARS_GLOBAL.dir_root;
rle = true;
if (nargin>2)
    outfile = varargin{1};
end
if (nargin>3)
    dir_root = varargin{2};
end
if (nargin>4)
    rle = varargin{3};
end

files_num = length(files);
features_num = size(features_spec,1);

F = features_struct;
F.dir_root = dir_root;
F.features_spec = features_spec;
F.features = cell(files_num,1);
F.files = files;
F.files_sampling_rate = zeros(files_num,1);

t_read = 0;
t_feature = 0;
for k = 1:files_num
    skelfile_fullpath = [dir_root files{k,1}];
    motfile_fullpath = [dir_root files{k,2}];
    F.features{k} = cell(features_num,1);
    disp([num2str(k) '/' num2str(files_num) ': ' skelfile_fullpath]);
    
    [F.features{k},F.files_sampling_rate(k),tr,tf] = features_extract_single_file_nonmocada(skelfile_fullpath, motfile_fullpath, features_spec, rle);
    t_read = t_read + tr;
    t_feature = t_feature + tf;
end

if (~isempty(outfile))
    save(outfile,'F');
end

varargout{1} = F; 
if (nargout>1)
    varargout{2} = t_read;
end
if (nargout>2)
    varargout{3} = t_feature;
end
