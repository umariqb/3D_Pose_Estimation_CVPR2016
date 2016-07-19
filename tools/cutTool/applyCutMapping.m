function applyCutMapping( cutMappingInputPathOrFile, inputPath, outputPath, fileType )
%
% applyCutMapping( cutMappingInputPathOrFile, inputPath, outputPath, fileType )
%
%       cutMappingInputPathOrFile: path to cutmapping (*.txt) files
%       inputPath                : path to C3D/AMC files
%       outputPath               : where to write the cut files
%       fileType                 : process 'amc' or 'c3d' or both if left empty
%

if nargin < 4
    fileType = [];
end
fileType = upper(fileType);

% check if first parameter refers to a single file or a path
if strcmp(cutMappingInputPathOrFile(end-3:end), '.txt')
    positions = strfind(cutMappingInputPathOrFile, '\');
    
    lastBackslashPosition = positions(length(positions));
    inputFiles{1} = cutMappingInputPathOrFile( lastBackslashPosition + 1 : length(cutMappingInputPathOrFile) );
    path = cutMappingInputPathOrFile(1:lastBackslashPosition);
    
else
    if cutMappingInputPathOrFile(end)~='\'
        cutMappingInputPathOrFile(end+1)='\';
    end
    path = cutMappingInputPathOrFile;
    inputFiles = dir([cutMappingInputPathOrFile '*.txt']);
    inputFiles = {inputFiles.name};
end

% preprocess inputPath and outputPath
if( isempty(strfind(inputPath, ':')) && inputPath(1)~='\') 
    inputPath = [cd '\' inputPath];
end
if inputPath(end)~='\'
    inputPath(end+1)='\';
end
if( isempty(strfind(outputPath, ':')) && outputPath(1)~='\') 
    outputPath = [cd '\' outputPath];
end
if outputPath(end)~='\'
    outputPath(end+1)='\';
end


for i=1:length(inputFiles)

    disp(['Processing ' path inputFiles{i} ' ...']);
    fCutMapping = fopen([path inputFiles{i}], 'r');
	
	if fCutMapping==-1
        h=errordlg(['File: ',cutMappingFileName,' could not be opened'],'application error');
        uiwait(h)
        return
	end
	
	% read cutMapping
	i = 1;
	while(~feof(fCutMapping))
        line = fgets(fCutMapping);
	
        if( line(1)=='"' )
            idxQuotes = strfind(line, '"');
            mappings(i).filename = line( idxQuotes(1)+1 : idxQuotes(2)-1 );
            line = line(idxQuotes(2):end);
            groups = regexp( line, '\w*' );
		
            mappings(i).frameFrom   = str2num(line(groups(1)-1:(groups(2)-1)));
            mappings(i).frameTo     = str2num(line(groups(2)-1:(groups(3)-1)));
            mappings(i).newFilename = deblank(line(groups(3):end));
            i = i+1;
        end
	end
	
	% perform the cutting
	for i=1:length(mappings)
%         fileExt = mappings(i).filename( max(strfind(mappings(i).filename, '.')):end);
        fullInputFilenameAMC = upper([inputPath mappings(i).filename]);
        fullInputFilenameC3D = strrep(lower(fullInputFilenameAMC), 'hdm05_amc', 'hdm05_c3d');
        fullInputFilenameC3D = upper(strrep(fullInputFilenameC3D, '.amc', '.c3d'));
        
        fullOutputFilename = [outputPath mappings(i).newFilename];
  
        if isempty(fileType)
            cutAMC( fullInputFilenameAMC, [fullOutputFilename '.AMC'], mappings(i).frameFrom, mappings(i).frameTo );
            cutC3d( fullInputFilenameC3D, [fullOutputFilename '.C3D'], mappings(i).frameFrom, mappings(i).frameTo );
        elseif strcmp(fileType, 'AMC')
            cutAMC( fullInputFilenameAMC, [fullOutputFilename '.AMC'], mappings(i).frameFrom, mappings(i).frameTo );
        elseif strcmp(fileType, 'C3D')
            cutC3d( fullInputFilenameC3D, [fullOutputFilename '.C3D'], mappings(i).frameFrom, mappings(i).frameTo );
        end
%         if strcmp(upper(fileExt), '.AMC') 
%             cutAMC( fullInputFilename, fullOutputFilename, mappings(i).frameFrom, mappings(i).frameTo );
%         elseif strcmp(upper(fileExt), '.C3D') 
%             cutC3d( fullInputFilename, fullOutputFilename, mappings(i).frameFrom, mappings(i).frameTo );
%         end
        
        disp(['   ' outputPath mappings(i).newFilename]);
	end
    
    fclose(fCutMapping);
end