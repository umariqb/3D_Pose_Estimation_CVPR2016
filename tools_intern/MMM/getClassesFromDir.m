function classes=getClassesFromDir(path)

% path=fullfile(path);

tmp=dir(path);

j=1;
for i=1:size(tmp,1)
    if (     tmp(i).isdir&& ... 
            ~strcmp(tmp(i).name,'.')&& ...
            ~strcmp(tmp(i).name,'..'))
        
        classes{j}=tmp(i).name;
        j=j+1;
    end
end