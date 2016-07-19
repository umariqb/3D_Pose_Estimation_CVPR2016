function loadAllFiles( inputPath )
% 
% attempts to load all *.C3D-files in given input-directory (for testing purposes)
%

oldPath = cd;

% preprocess path
if( isempty(strfind(inputPath, ':')) && inputPath(1)~=filesep) 
    inputPath = [cd filesep inputPath];
end
if(inputPath(end)~=filesep)
    inputPath(end+1) = filesep;
end

cd(inputPath);
fileList = dir;

for i=1:length(fileList)
    
    filename = fileList(i).name;
    
    if fileList(i).isdir 
        if not(strcmp(filename, '.')) && not(strcmp(filename, '..'))
            cd(oldPath);
            loadAllFiles( [inputPath filename] );
        end
    else   
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.C3D'))
            disp([inputPath filename]);
            [skel, mot] = readMocap([inputPath filename], [inputPath filename], [], true, false);
        elseif(strcmp(upper(ext), '.AMC'))
            disp([inputPath filename]);
            [skel, mot] = readMocap([inputPath filename(1:6) '.ASF'], [inputPath filename]);
        end
    end
end

cd(oldPath);
