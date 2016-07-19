function varargout = features_modify_files(F, files_new, varargin)
% [F_new, t_read, t_feature] = features_modify_files(F, files_new, outfile, dir_root, rle, silent)
%
% Add or remove files to/from an existing feature data structure (for all features).
% This is done by specifying a desired file set. New files will be added, missing ones will be removed.
%
% F.............. feature data structure
% files_new...... cell array of file names that will constitute the new feature database
% outfile ....... if specified, name of mat file to save results to; default: empty
% dir_root ...... path prefix for file names; default:  VARS_GLOBAL.dir_root
% rle............ boolean flag indicating whether run length encoding is to be applied; default: true
%
% opt. returns .. [F_new, t_read, t_feature] (timing info for read-in (t_read) and feature extraction (t_feature))


global VARS_GLOBAL;

outfile = '';
dir_root = '';
rle = true;
silent = false;
if (nargin>2)
    outfile = varargin{1};
end
if (nargin>3)
    dir_root = varargin{2};
end
if (nargin>4)
    rle = varargin{3};
end
if (nargin>5)
    silent = varargin{4};
end

if (isempty(dir_root))
    dir_root = VARS_GLOBAL.dir_root;
end

nfeatures = length(F.features_spec);
nfiles_new = length(files_new);
files_old = F.files;

if (isnumeric(files_new))
    files_new = files_old(files_new);
end

F_new = features_struct;
%struct('features',cell(1,1),'features_spec',F.features_spec,'files',cell(1,1),'dir_root',F.dir_root);
F_new.features = cell(nfiles_new,1);
F_new.files = files_new;
F_new.dir_root = F.dir_root;
F_new.features_spec = F.features_spec;

%%% determine which files are to be kept/added/removed
[f_keep, I_keep_old, I_keep_new] = intersect(files_old, files_new); 
[f_add, I_add_new] = setdiff(files_new, files_old);
[f_rem, I_rem_old] = setdiff(files_old, files_new);

%%% display some information about what's going to be done
if (~silent)
    disp(['Removing the following ' num2str(length(I_rem_old)) ' files:']);
    for k=1:length(I_rem_old)
        disp(files_old{I_rem_old(k)});
    end
    disp(' ');
    disp(['Keeping the following ' num2str(length(I_keep_old)) ' files:']);
    for k=1:length(I_keep_old)
        disp(files_old{I_keep_old(k)});
    end
end
%%% rearrange files to be kept
F_new.features(I_keep_new) = F.features(I_keep_old);
F_new.files_sampling_rate(I_keep_new) = F.files_sampling_rate(I_keep_old);
if (size(F_new.files_sampling_rate,1)==1)
    F_new.files_sampling_rate = F_new.files_sampling_rate';
end

%%% now, add files 
nf_add = length(I_add_new);
if (nf_add>0)
    if (~silent)
        disp(' ');
        disp(['Adding the following ' num2str(length(I_add_new)) ' files:']);
        for k=1:length(I_add_new)
            disp(files_new{I_add_new(k)});
        end
    end
end

t_read = 0;
t_feature = 0;
for k = 1:nf_add
    file_fullpath = [dir_root F_new.files{I_add_new(k)}];
    F_new.features{I_add_new(k)} = cell(nfeatures,1);

    if (~silent)
        disp([num2str(k) '/' num2str(nf_add) ': ' file_fullpath]);
    end
    
    [F_new.features{I_add_new(k)},F_new.files_sampling_rate(I_add_new(k)),tr,tf] = features_extract_single_file(file_fullpath, F.features_spec, rle);
    t_read = t_read + tr;
    t_feature = t_feature + tf;
end

if (~isempty(outfile))
    save(outfile,'F_new');
end

varargout{1} = F_new; 
if (nargout>1)
    varargout{2} = t_read;
end
if (nargout>2)
    varargout{3} = t_feature;
end
