function nameMap = mocapRenamer( inputPath, outputPath, simulate, creatorString, framerate )
% mocapRenamer( inputPath, outputPath, simulate, creatorString, framerate )
% 
% The following default values are assumed if parameters are not given:
%   inputPath     = current directory
%   outputPath    = inputPath
%   simulate      = false
%   creatorString = 'HDM'
%   framerate     = '120' (this is just for naming purposes)

tic;

if nargin < 5
    framerate = '120';
end
if nargin < 4
    creatorString = 'HDM';
end
if nargin < 3
    simulate = false;
end
if nargin < 2
    outputPath = inputPath;
end
if (nargin < 1) || (strcmp(inputPath, '.'))
    inputPath = cd;
end

oldPath = cd;

% convert relative to absolute paths
cd(inputPath);
inputPath = cd;
cd(oldPath);
cd(outputPath);
outputPath = cd;

% generate fileList
disp('Parsing files ...');

fileList = processDirectory(inputPath);

% try to gather information from paths and filenames -------------------------------------------------------------------------------------------
disp('Gathering file information ...');

for i=1:length(fileList)
    fileList(i).actorName = parseActorName([fileList(i).path '\' fileList(i).filename]);
    
    if not(isempty(strmatch( fileList(i).extension, {'c3d', 'amc', 'bvh'} )))
        fileList(i).chapter = parseChapter(fileList(i).filename);
    end
end


% collect directory information --------------------------------------------------------------------------------------------------------------
disp('Figuring out directory structure ...');

directories = [];

for i=1:length(fileList)    
    
    if not(isempty(strmatch( fileList(i).directory, {'c3d', 'asf_amc', 'bvh'} )))
    
        newDir = {fileList(i).directory fileList(i).actorName};
        
        if isempty(directories)
            directories{1} = newDir;
        else
            found = false;
            for j=1:length(directories)
                if strcmp(directories{j}, newDir) == [1 1]
                    found = true;
                    break;
                end
            end
            if not(found)
                directories{length(directories) + 1 } = newDir;
            end
        end
        
    end
end

% create directories --------------------------------------------------------------------------------------------------------------
if not(simulate)
	disp('Creating directory structure ...');
	
	warning off MATLAB:MKDIR:DirectoryExists;
	for i=1:length(directories)
        cd(outputPath);
        mkdir(char(directories{i}(1)));
        cd(char(directories{i}(1)));
        mkdir(char(directories{i}(2)));
        cd(char(directories{i}(2)));
	end
	warning on MATLAB:MKDIR:DirectoryExists
end

% begin copying --------------------------------------------------------------------------------------------------------------
disp('Copying files ...');

takes = [];     % remember the number of takes for each actor/chapter combination. Necessary for renumbering the takes.

for i=1:length(fileList)
    
    fromFile = [fileList(i).path '\' fileList(i).filename];
    
    if not(isempty(strmatch( fileList(i).extension, {'c3d', 'amc', 'bvh'} )))   % don't create new filenames for other files that happen to be found
        found = false;
        take = 1;
        for j=1:length(takes)
            if strcmp(takes{j}{1}, { fileList(i).actorName, fileList(i).chapter, fileList(i).extension }) == [1 1 1]
                take = takes{j}{2} + 1;
                takes{j}{2} = take;
                found = true;
                break;
            end
        end
        if not(found)
            takes{length(takes)+1} = { { fileList(i).actorName, fileList(i).chapter, fileList(i).extension }, 1 };
        end
        
        toFilename = [creatorString '_' fileList(i).actorName '_' fileList(i).chapter '_' num2str(take,'%02d') '_' framerate '.' fileList(i).extension];
        
    elseif not(isempty(strmatch( fileList(i).extension, {'vsk', 'asf' } )))
        toFilename = [creatorString '_' fileList(i).actorName '.' fileList(i).extension];
    else
        toFilename = fileList(i).filename;
    end
    
    toFile = [outputPath '\' fileList(i).directory '\' fileList(i).actorName '\' toFilename];

    if not(simulate)
        disp(['copying ' fromFile ' => ' toFile]);
        [s,w] = dos(['copy ' fromFile ' ' toFile]);
    end

    nameMap{i,1} = fileList(i).filename;
    nameMap{i,2} = [fileList(i).directory '\' fileList(i).actorName '\' toFilename];
end

cd(oldPath);
save nameMap.mat nameMap;

toc