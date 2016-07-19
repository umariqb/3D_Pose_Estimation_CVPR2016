function checkDB( inputPath )
% checks DB for various conditions (-> output)
%
%       checkDB( inputPath )


if nargin < 1
    global VARS_GLOBAL;
    inputPath = VARS_GLOBAL.dir_root;
end

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
disp(['Processing ' inputPath ' ...']);

if isempty(strmatch('skip', {fileList.name}))
    for i=1:length(fileList)
        
        filename = fileList(i).name;
        
        if fileList(i).isdir 
            if not(strcmp(filename, '.')) && not(strcmp(filename, '..'))
                cd(oldPath);
                checkDB( [inputPath filename] );
            end
        else    
            ext  = filename(end-3:end);
            
            if(strcmp(upper(ext), '.MAT'))
                
                load([inputPath filename], 'skel', 'mot');
                if exist('skel') && exist('mot')
                    ext2  = filename(end-7:end-4);
                    
                    if strcmpi(ext2, '.C3D')
                        % C3D: check if point cloud-version was cached
                        if length(skel.paths) < 30
                            disp(['  ' inputPath filename ':  generated Skel was stored in *.MAT!']);
                        end
                        % check nameMaps for RBAC-entries
                        if length(strmatch('RBAC', upper(mot.nameMap(:,1)))) > 1
                            disp(['  ' inputPath filename ':  Found more than one RBAC-entry in mot.nameMap!']);
                        end
                        
                    elseif strcmpi(ext2, '.AMC')
                        % ASF/AMC: check if ASF is there
                        asfFilename = [inputPath filename(1:6) '.asf'];
                        h = fopen(asfFilename, 'r');
                        if h==-1
                            disp(['  ' inputPath filename ':  corresponding *.ASF could not be found!']);
                        else
                            fclose(h);
                        end
                    end
                    
                    % check filenames for absolute paths
                    if not(isempty(strfind(mot.filename, ':')))
                        disp(['  ' inputPath filename ':  Found absolute filename!']);
                    end
                end            
            end
        end
    end
end
cd(oldPath);
