function patch_fixFilenames( inputPath )
%
% PROBLEM:  Full path stored in mot.filename
%
% SOLUTION: Truncates path from filename
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

disp(inputPath);

fileList = dir;

for i=1:length(fileList)
    
    filename = fileList(i).name;
    
    if fileList(i).isdir 
        if not(strcmp(filename, '.')) && not(strcmp(filename, '..'))
            cd(oldPath);
            patch_fixFilenames( [inputPath filename] );
        end
    else    
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.MAT'))
            
            load([inputPath filename], 'skel', 'mot');
            if exist('skel') && exist('mot')
                modified = false;
                
                idx = findstr(mot.filename, '\');
                if not(isempty(idx))
                    mot.filename = mot.filename(idx(end)+1:end);
                    modified = true;
                end

                idx = findstr(skel.filename, '\');
                if not(isempty(idx))
                    skel.filename = skel.filename(idx(end)+1:end);
                    modified = true;
                end

                if modified
                    disp(['   modified: ' inputPath filename]);
                    save([inputPath filename], 'skel', 'mot');
                end
            end
        end            
    end
end

cd(oldPath);
