function D = rename_feature_to_BD(fullpath)

D = '';

I = findstr(fullpath,'feature_');
if (isempty(I))
    return
end
I = findstr(fullpath,'feature_BD');
if (~isempty(I))
    return
end

new_fullpath = strrep(fullpath,'feature_','feature_BD_');
movefile(fullpath,new_fullpath);

D = new_fullpath;

% y = forAllFilesInDir('S:\roedert\matlab\mocap_new\features\BD',{'*.m'},@rename_feature_to_BD,false,{});