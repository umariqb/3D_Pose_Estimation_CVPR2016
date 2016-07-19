function sortCutFiles( inputPath, substringStart, substringDelimiter )
%
% sortCutFiles( inputPath, substringStart, substringDelimiter )
%
%       Moves all files found in "inputPath" to subfolders being named like
%       the substring of their filename starting at "substringStart" and
%       being delimited by "substringDelimiter". If the subfolders are not
%       existent yet they will be created. Default values are
%       substringStart==8 and substringDelimiter=='_'.
%
%       Example: 
%       If subStringStart == 8 and substringDelimiter=='_', the file 
%       "HDM_dg_elbowToKnee3RepsRelbowStart_007_120.amc"
%       will be moved to subfolder named "elbowToKnee3RepsRelbowStart".
%
if nargin < 3
    substringDelimiter = '_';
end
if nargin < 2
    substringStart = 8;
end

if( isempty(strfind(inputPath, ':')) && inputPath(1)~='\') 
    inputPath = [cd '\' inputPath];
end
if inputPath(end)~='\'
    inputPath(end+1) = '\';
end

oldPath = cd;
cd(inputPath);
fileListAMC = dir([inputPath '*.amc']);
fileListC3D = dir([inputPath '*.c3d']);
% fileList = cat(1, fileListAMC, fileListC3D);

if not(exist('c3d', 'dir'))
    mkdir('c3d');
end

cd('c3d');

for i=1:length(fileListC3D)
    fileName = fileListC3D(i).name;
    delimIdx = strfind(fileName(substringStart:end), '_');
    motType = fileName(substringStart:substringStart+delimIdx(1)-2);
    
    if not(exist(motType, 'dir'))
        mkdir(motType);
    end
    
    fromFile = [inputPath fileName];
    toFile = [inputPath 'c3d\' motType '\' fileName];
    dos(['move ' fromFile ' ' toFile]);
    disp(fromFile);
end

cd(inputPath);  

if not(exist('amc', 'dir'))
    mkdir('amc');
end

cd('amc');

for i=1:length(fileListAMC)
    fileName = fileListAMC(i).name;
    delimIdx = strfind(fileName(substringStart:end), '_');
    motType = fileName(substringStart:substringStart+delimIdx(1)-2);
    
    if not(exist(motType, 'dir'))
        mkdir(motType);
    end
    
    fromFile = [inputPath fileName];
    toFile = [inputPath 'amc\' motType '\' fileName];
    dos(['move ' fromFile ' ' toFile]);
    disp(fromFile);
end
cd(oldPath);    