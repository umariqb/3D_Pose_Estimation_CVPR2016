function [features, filenames] = features_decode_subdir(subdirs,indexname,varargin)
% [features, names] = features_decode_subdir(subdirs,indexname,recursive,fileranges,downsampling_fac)
% EXAMPLE: features = features_decode_subdir({'HDM\Training\squat3Reps','HDM\Training\squat1Reps'},'improved_lower',false,{1:10,1:20})
% indexname................. can be a cell array of strings. In that case, the features for each index will be concatenated vertically.

global VARS_GLOBAL

if (~iscell(subdirs))
    subdirs = {subdirs};
end

if (~iscell(indexname))
    indexname = {indexname};
end

recursive = false;
fileranges = {};
downsampling_fac = 1;
if (nargin>4)
    downsampling_fac = varargin{3};
end
if (nargin>3)
    fileranges = varargin{2};
    if (~iscell(fileranges))
        fileranges = {fileranges};
    end
end
if (nargin>2)
    recursive = varargin{1};
end    

filenames = {};
features = {};
nfiles_processed = 0;
for j=1:length(subdirs)
    if (recursive)
        dirlist = createDirList(fullfile(VARS_GLOBAL.dir_root,subdirs{j}));    
    else
        dirlist = {fullfile(VARS_GLOBAL.dir_root,subdirs{j})};
    end
    for i = 1:length(dirlist)
        for f=1:length(indexname)
            fullpath = fullfile(dirlist{i},['F_' indexname{f} '.mat']);
            fid = fopen(fullpath);
            if (fid ~= -1)
                fclose(fid);
                load(fullpath);
            else
                continue;
            end
            
            if (length(fileranges)>=j)
                filerange = fileranges{j};
                h = intersect(filerange,[1:length(F.files)]);
                if (length(h)<length(filerange))
                    warning('Invalid file range! I will only consider files that actually exist.');
                    filerange = h;
                end
            else
                filerange = [1:length(F.files)];
            end
            
            nfiles = length(filerange);
            for k=1:nfiles
                if (f<=1) % insert the features for indexname{1}
                    if (downsampling_fac > 1)
                        features_downsampled = features_decode_single_file(F,filerange(k));
                        features_downsampled = features_downsampled(:,1:downsampling_fac:end);
                        features{k+nfiles_processed,1} = features_downsampled;
                    else
                        features{k+nfiles_processed,1} = features_decode_single_file(F,filerange(k));
                    end
                    filenames{k+nfiles_processed,1} = F.files{filerange(k)};
                else % append the features for indexname{2}...indexname{m}
                    if (downsampling_fac > 1)
                        features_downsampled = features_decode_single_file(F,filerange(k));
                        features_downsampled = features_downsampled(:,1:downsampling_fac:end);
                        features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_downsampled];
                    else
                        features{k+nfiles_processed,1} = [features{k+nfiles_processed,1}; features_decode_single_file(F,filerange(k))];
                    end
                end
            end
            if (f==length(indexname)) % only count files once, not length(indexname) times
                nfiles_processed = nfiles_processed + nfiles;
            end
        end
    end
end


