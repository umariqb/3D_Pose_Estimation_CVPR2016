function [ output_args ] = patch_fixCorruptedNameMaps( inputPath )
%
% PROBLEM:  Some files have corrupted nameMaps with missing label names.
%
% SOLUTION: Tries to identify trajectories for missing label and corrects 
%           both C3D-file and MAT-file.
%
% PARAMETERS:
%           inputPath: Path to database, e.g. 'F:\mocap\HDM05'
%
viconNames = {'LFHD', 'RFHD', 'LBHD', 'RBHD', 'C7'   'T10'  'CLAV', 'STRN', 'RBAC', 'LSHO', 'LUPA', 'LELB', 'LFRM', 'LWRA', ...
        'LWRB', 'LFIN', 'RSHO', 'RUPA', 'RELB', 'RFRM', 'RWRA', 'RWRB', 'RFIN', 'LFWT', 'RFWT', 'LBWT', 'RBWT', 'LTHI', ...
        'LKNE', 'LSHN', 'LANK', 'LHEE', 'LTOE', 'LMT5', 'RTHI', 'RKNE', 'RSHN', 'RANK', 'RHEE', 'RTOE', 'RMT5'};

labelPrefix = {'bd', 'Bastian'; 'bk', 'bjorn'; 'dg', 'Daniel'; 'mm', 'meinard'; 'tr', 'Tido'};

global VARS_GLOBAL;
VARS_GLOBAL.missing = viconNames';
VARS_GLOBAL.missing(:,2) = mat2cell(zeros(41,1),ones(41,1));
VARS_GLOBAL.identified = viconNames';
VARS_GLOBAL.identified(:,2) = mat2cell(zeros(41,1),ones(41,1));

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
            patch_fixCorruptedNameMaps( [inputPath filename] );
        end
    else    
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.C3D'))
            disp([inputPath filename]);
            cd(oldPath);            
            [skel, mot] = readMocap([inputPath filename], [inputPath filename], [], true, false);
            nameMap = getNameMapFromC3D([inputPath filename]);
            mot.nameMap = nameMap;
            missing = {};
            
            for i=1:length(viconNames)
                vicon = viconNames{i};
                idx = strmatch(vicon, nameMap(:,1));
                if isempty(idx)
                    
                    idx = feval(['get' upper(vicon)], mot);
                    
                    if strfind(nameMap{idx, 1}, '*')                        
                        disp(['   Label "' vicon '" could be identified with "' nameMap{idx, 1} '".']);
                        prefix = labelPrefix{strmatch(filename(5:6), labelPrefix),2};
                        correctC3DLabelName([inputPath filename], idx, nameMap{idx,1}, [prefix ':' vicon]);
                        updateNameMap([inputPath filename '.MAT']);
                        
                        mot.nameMap{idx,1}=vicon;
                        VARS_GLOBAL.identified{strmatch(vicon, viconNames),2} = VARS_GLOBAL.identified{strmatch(vicon, viconNames),2}+1;
                    else
                        disp(['   Label "' vicon '" could not be found, closest other joint is "' nameMap{idx, 1} '"']);
                        missing{end+1} = vicon;
                        VARS_GLOBAL.missing{strmatch(vicon, viconNames),2} = VARS_GLOBAL.missing{strmatch(vicon, viconNames),2}+1;
                    end
                end
            end
            if length(missing) > 0
                stars = strmatch('*', mot.nameMap(:,1));
                disp([ 'Did not find ' num2str(length(missing)) ' label(s), with ' num2str(length(stars)) ' markers still unidentified.']);
                findDuplicateTrajectories(mot);
                disp(' ');
            end
        end            
    end
end

cd(oldPath);
