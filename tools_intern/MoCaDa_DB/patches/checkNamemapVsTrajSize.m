function [ output_args ] = checkNamemapVsTrajSize( inputPath )
%CHECKNAMEMAPVSTRAJSIZE Summary of this function goes here
%  Detailed explanation goes here

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
            checkNamemapVsTrajSize( [inputPath filename] );
        end
    else   
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.MAT'))
%             [skel, mot] = readMocap([inputPath filename], [inputPath filename], [], true, false);
            load([inputPath filename], 'skel', 'mot');
            if length(mot.jointTrajectories) < 39
                disp([inputPath filename]);
                disp(['  nameMap has size ' num2str(length(mot.nameMap)) ' and there are ' num2str(length(mot.jointTrajectories)) ' trajectories.']);
            end
        end
        
    end
end

cd(oldPath);
