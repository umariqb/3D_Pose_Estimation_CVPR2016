function applySkelfitToDir( inputPath )

oldPath = cd;

% preprocess path
if( isempty(strfind(inputPath, ':')) && inputPath(1)~='\') 
    inputPath = [cd '\' inputPath];
end
if(inputPath(end)~='\')
    inputPath(end+1) = '\';
end

cd(inputPath);
fileList = dir;

for i=1:length(fileList)
    
    filename = fileList(i).name;
    
    if fileList(i).isdir 
        if not(strcmp(filename, '.')) && not(strcmp(filename, '..'))
            cd(oldPath);
            applySkelfitToDir( [inputPath filename] );
        end
    else    
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.C3D'))
            cd(oldPath);
            
            [skel, mot] = readMocap([inputPath filename], [inputPath filename]);
            mot = skelfitOptT(mot);
            save([inputPath filename '.MAT'], 'skel', 'mot');
            disp([inputPath filename]);
        end            
    end
end

cd(oldPath);
