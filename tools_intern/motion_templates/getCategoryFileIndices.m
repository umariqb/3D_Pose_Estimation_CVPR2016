function y = getCategoryFileIndices(category_relpath,motions_to_use_num,rel)

global VARS_GLOBAL

files = dir([VARS_GLOBAL.dir_root filesep category_relpath filesep '*.amc']); 
if isempty(files)
    files = dir(fullfile(VARS_GLOBAL.dir_root, category_relpath, '*.c3d')); 
end
    
files_num = length(files);
y.path = category_relpath;
y.files_num = files_num;
if (files_num<=1)
    y.used = [0];
    y.unused = [0];
    return;
end

if (rel)
    motions_to_use_num = max(2,min(files_num,ceil(files_num*motions_to_use_num)));
else
    motions_to_use_num = max(2,min(files_num,motions_to_use_num));
end
%% spread motions_to_use_num numbers evenly in the range 1:files_num
files = floor([0:motions_to_use_num-1]*files_num/motions_to_use_num) + 1;

y.used = files;
y.unused = setdiff([1:files_num],files);
if (isempty(y.used))
    y.used = [0];
end
if (isempty(y.unused))
    y.unused = [0];
end
