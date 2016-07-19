function D = addFileToD(amcfullpath,root_dir)

[info,OK] = filename2info(amcfullpath);
if (OK)
    D = struct('file_name',info.amcname,'path_name',info.amcpath(length(root_dir)+1:end));
else
    k = strfind(amcfullpath,filesep);
    file_name = amcfullpath(k(end)+1:end);
    D = struct('file_name',file_name,'path_name',amcfullpath(length(root_dir)+1:end-length(file_name)));
end

