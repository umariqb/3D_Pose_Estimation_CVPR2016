function varargout = features_modify_features(F, f_new, varargin)
% [F_new, t_read, t_feature] = features_modify_features(F, f_new, outfile, dir_root, rle)
%
% Add or remove features to/from an existing feature data structure (for all files).
% This is done by specifying a desired feature set. New features will be added, missing ones will be removed.
%
% F.............. feature data structure
% f_new.......... struct array of feature specifications
% outfile ....... if specified, name of mat file to save results to; default: empty
% dir_root ...... path prefix for file names; default:  VARS_GLOBAL.dir_root
% rle............ boolean flag indicating whether run length encoding is to be applied; default: true
%
% opt. returns .. [F_new, t_read, t_feature] (timing info for read-in (t_read) and feature extraction (t_feature))


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

nfiles = length(F.files);
nf_new = length(f_new);

f_old = F.features_spec;
nf_old = length(F.features_spec);

F_new = features_struct;
F_new.dir_root = F.dir_root;
F_new.features_spec = f_new;
F_new.features = cell(nfiles,1);
F_new.files = F.files;
F_new.files_sampling_rate = F.files_sampling_rate;

f_old_names = features_spec_unique_name(f_old);
f_new_names = features_spec_unique_name(f_new);

%%% determine which features are to be kept/added/removed
[f_keep, I_keep_old, I_keep_new] = intersect(f_old_names, f_new_names); 
[f_add, I_add_new] = setdiff(f_new_names, f_old_names);
[f_rem, I_rem_old] = setdiff(f_old_names, f_new_names);

nf_rem = length(I_rem_old);
if (nf_rem>0)
    %%% display some information about what's going to be done
    disp(['Removing the following ' num2str(length(I_rem_old)) ' features:']);
    for k=1:length(I_rem_old)
        disp(f_old_names{I_rem_old(k)});
    end
    disp(' ');
end

disp(['Keeping the following ' num2str(length(I_keep_old)) ' features:']);
for k=1:length(I_keep_old)
    disp(f_old_names{I_keep_old(k)});
end

nf_add = length(I_add_new);
if (nf_add>0)
    disp(' ');
    disp(['Adding the following ' num2str(length(I_add_new)) ' features:']);
    for k=1:length(I_add_new)
        disp(f_new_names{I_add_new(k)});
    end
end
%%% now, add features and rearrange features to be kept
	t_read = 0;
	t_feature = 0;
	for k = 1:nfiles
        F_new.features{k} = cell(nf_new,1);
        F_new.features{k}(I_keep_new) = F.features{k}(I_keep_old);
        if (nf_add>0)
            file_fullpath = [dir_root F_new.files{k}];
            disp([num2str(k) '/' num2str(nfiles) ': ' file_fullpath]);
            [F_new.features{k}(I_add_new),F_new.files_sampling_rate(k),tr,tf] = features_extract_single_file(file_fullpath, f_new(I_add_new), rle);
            t_read = t_read + tr;
            t_feature = t_feature + tf;
        end
	end
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
