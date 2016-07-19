function fileList = processDirectory( path, showOutput )

if nargin < 2
    showOutput = false;
end

oldPath = cd;
cd(path)

files = dir;
[h,I] = sort({files.name});     % sorting is necessary to assure the same take-numbers for .amc and .c3d versions during renaming
files = files(I);

fileCount = 0;
fileList = [];

path = cd;   % necessary if the path parameter is relative (e.g. path == '../test')

for i=1:size(files,1)
    name = files(i).name;
    if files(i).isdir 
        if not(strcmp(name, '.')) && not(strcmp(name, '..'))
            if showOutput 
                disp(['*** processing subdir: ' name ' ***']);
            end
            subFileList = processDirectory( [path '\' name] );
            fileList = [fileList subFileList];
        end
    else
        if showOutput 
            disp(['processing ' name ' ...']);
        end
        fileCount = fileCount + 1;
        fileList(fileCount).path = path;
        fileList(fileCount).filename = name;
        fileList(fileCount).extension = lower( name ( (max(findstr(name,'.'))+1) : length(name) ) );
        fileList(fileCount).directory = lower( path ( (max(findstr(path,'\'))+1) : length(path) ) );
    end
end
if fileCount > 0 && showOutput
    disp(['   ... processed ' int2str(fileCount) ' files.']);
end
eval(['cd ' oldPath]);
