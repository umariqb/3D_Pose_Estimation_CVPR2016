function y = features_extract_subdir(fullpath_source,fspec,varargin)

global VARS_GLOBAL

fullpath_dest = '';
motionCategory = '';
search_files_recursive = false;
if (nargin>4)
    search_files_recursive = varargin{3};
end
if (nargin>3)
    motionCategory = varargin{2};
end
if (nargin>2)
    fullpath_dest = varargin{1};
end

y = fullpath_source;

%%%% collect AMC/BVH files in current dir
D = createD(fullpath_source,VARS_GLOBAL.dir_root,search_files_recursive);
files = D2filenames(D);
if (isempty(files))
    return;
end

if (isempty(motionCategory))
    motionCategory = 'unknownCategory';
    [files_info,OK] = filename2info(files{1});
    if (OK)
        motionCategory = files_info.motionCategory;
    end
end

%%%%% extract features and save to directory fullpath_dest
for k=1:size(fspec,1)
    F = features_extract(files,fspec{k,1},'',VARS_GLOBAL.dir_root);
    if (isempty(fullpath_dest)) % save directly to source directory without motion category
        save([fullpath_source filesep 'F_' fspec{k,2} filesep '.mat'], 'F');
    else % destination path specified; use destination directory and add motion category in file name
        d = dir([fullpath_dest filesep fspec{k,2}]);               
        if (isempty(d))
            mkdir(fullpath_dest,fspec{k,2});
        end
        save([fullpath_dest filesep fspec{k,2} filesep 'F_' fspec{k,2} '_' motionCategory '.mat'], 'F');
    end
end

