function patch_AsfFiles( inputPath )
%
% PROBLEM:  ASF-files are not located in each subdirectory of 'HDM05_cut_amc',
%           so they can not be found by the parser.
%
% SOLUTION: Copies ASF-files from 'HDM05_cut_amc' to each subdirectory
%
% PARAMETERS:
%           inputPath: Path to 'HDM05_cut_amc', e.g. 'F:\mocap\HDM05\HDM05_cut_amc'
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

for i=1:length(fileList)
    
    if fileList(i).isdir 
        dirName = fileList(i).name;
        if not(strcmp(dirName, '.')) && not(strcmp(dirName, '..'))
            disp([inputPath dirName]);
            [s,w] = dos(['copy ' inputPath '*.ASF ' inputPath dirName]);
        end
    end
end

cd(oldPath);
