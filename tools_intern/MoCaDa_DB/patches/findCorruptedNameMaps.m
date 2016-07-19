function findCorruptedNameMaps( inputPath )

viconNames = {'LFHD', 'RFHD', 'LBHD', 'RBHD', 'C7'   'T10'  'CLAV', 'STRN', 'RBAC', 'LSHO', 'LUPA', 'LELB', 'LFRM', 'LWRA', ...
              'LWRB', 'LFIN', 'RSHO', 'RUPA', 'RELB', 'RFRM', 'RWRA', 'RWRB', 'RFIN', 'LFWT', 'RFWT', 'LBWT', 'RBWT', 'LTHI', ...
              'LKNE', 'LSHN', 'LANK', 'LHEE', 'LTOE', 'LMT5', 'RTHI', 'RKNE', 'RSHN', 'RANK', 'RHEE', 'RTOE', 'RMT5'};

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
            findCorruptedNameMaps( [inputPath filename] );
        end
    else    
        ext  = filename(end-3:end);
        
        if(strcmp(upper(ext), '.MAT'))

            ext2 = filename(end-7:end-4);

            if(strcmp(upper(ext2), '.C3D'))
%                 filenameDisplayed = false;

                load([inputPath filename], 'skel', 'mot');
                
                if not(isempty(strmatch('RBAC', mot.nameMap(:,1))))
                    occ = length(strmatch('RBAC', mot.nameMap(:,1)));
                    nms = length(mot.nameMap);
                    disp([filename ': ' num2str(occ) ' occurences, nameMap is size ' num2str(nms) ', difference is ' num2str(nms-occ)]);
                else
                    disp('ok');
                end

                for i=1:length(viconNames)
                    vicon = viconNames{i};
                    idx = strmatch(vicon, mot.nameMap(:,1));
                    if isempty(idx)
%                         if not(filenameDisplayed)
%                             disp(filename);
%                             filenameDisplayed = true;
%                         end
                        disp(['    "' vicon '" missing.']);
                    end
                end
            end            
        end
    end
end

cd(oldPath);
