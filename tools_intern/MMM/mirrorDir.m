function mirrorDir(path)


pathamc=fullfile(path,'*.amc');

files=dir(pathamc);

for curfile=1:size(files,1)
    infos=filename2info(files(curfile).name);
    
    [skel,mot]=readMocap( ...
        fullfile(path,infos.asfname), ...
        fullfile(path,files(curfile).name));
    
    [skel2,mot2]=mirrorMot(skel,mot);
    
    underscores=strfind(files(curfile).name,'_');
    
    outamc=[files(curfile).name(1:underscores(3)-1) ...
           'Mirrored' ...
            files(curfile).name(underscores(3):end)];
    
    writeAMC(skel2,mot2,fullfile(path,outamc));
end