function patch_updateNameMaps( inputPath )
%
% PROBLEM:  Some *.MAT files don't have a proper nameMap
%
% SOLUTION: Generates new nameMap by reading corresponding C3D file
%
% PARAMETERS:
%           inputPath: Path to database, e.g. 'F:\mocap\HDM05'
%


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

if sum(ismember({fileList.name}, 'skip'))>=1
    return;
end

for i=1:length(fileList)
    
    filename = fileList(i).name;
    
    if fileList(i).isdir 
        if not(strcmp(filename, '.')) && not(strcmp(filename, '..'))
            cd(oldPath);
            patch_updateNameMaps( [inputPath filename] );
        end
    else    
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.MAT'))
            cd(oldPath);
            
            updateNameMap([inputPath filename]);
        end            
    end
end

cd(oldPath);
