function [returnFileName] = H_dirFilesUm(inputDB, inputPath, inputFileName, format, savePath)

%%
% The functions converts 2D pose text format file to Mat file requried by
% the code
%%
%inputDB = 'Human36Mbm';   % 'LeedSports' / 'HumanEva' / 'Human36Mbm' / 'Human80K'
%format  = 'old';   % new / old    % new format contains the weights of the nn
switch inputDB    
    case 'HumanEva'
        %% Final Files
        strPath = '../HumanEva/Derived Poses Final/Rebuttel_chSkelr2/';
      case 'Human36Mbm'        
        strPath = '../Data/';        
     case 'LeedSports'
        strPath = '../Work/LeedSports/Derived Poses/r1/'; 
        strPath = '../Work/LeedSports/Derived Poses/Rebuttelr2/';
    otherwise
        disp('H-error: please mention right input database ... ');
end
if(~isempty(inputPath))
    strPath = inputPath;
end

strPath = fullfile(strPath);
%%
token    = textscan(strPath, '%s', 'delimiter', '\\');
dirFiles = dir([strPath, '*.txt']);
endVal = length(dirFiles);
%%
switch inputDB
 %--------------------------------------------------------------------------
    case 'LeedSports'   
        if(isempty(inputFileName))
            for i=1:endVal
                [tmpName rem] = strtok(dirFiles(i).name,  '.');
                if (strcmp(rem,'.txt' ))
                    dimInfo = 2;  % 2 or 3
                    if(strcmp(format,'new'))
                        H_text2MotFileLS_new(dirFiles(i).name, strPath);
                    else
                        H_text2MotFileLS(dirFiles(i).name, strPath);
                    end
                end
            end
        else
            if(strcmp(format,'new'))
                H_text2MotFileLS_new(dirFiles(i).name, strPath);
            else
                H_text2MotFileLS(dirFiles(i).name, strPath);
            end
        end
%--------------------------------------------------------------------------    
    case 'HumanEva'
        if(isempty(inputFileName))
            for i=1:endVal
                [tmpName rem] = strtok(dirFiles(i).name,  '.');
                if (strcmp(rem,'.txt' ))
                    dimInfo = 2;  % 2 or 3
                    if(strcmp(format,'new'))
                        H_text2MotFileUm_2(dirFiles(i).name, strPath,dimInfo);
                    else
                        H_text2MotFileUm(dirFiles(i).name, strPath,dimInfo);
                    end
                end
            end
        else
            if(strcmp(format,'new'))
                H_text2MotFileUm_2(dirFiles(i).name, strPath,dimInfo);
            else
                H_text2MotFileUm(dirFiles(i).name, strPath,dimInfo);
            end
        end
%--------------------------------------------------------------------------
 %--------------------------------------------------------------------------        
    case 'Human36Mbm'
        if(isempty(inputFileName))
            for i=1:endVal
                [tmpName rem] = strtok(dirFiles(i).name,  '.');
                if (strcmp(rem,'.txt' ))
                    dimInfo = 2;  % 2 or 3
                    if(strcmp(format,'new'))
                      returnFileName = H_text2MotFileUmH36Mbm_wtnn(dirFiles(i).name, strPath, savePath);
                    else
                      returnFileName = H_text2MotFileUmH36Mbm(dirFiles(i).name, strPath, savePath);
                    end
                end
            end
        else
            if(strcmp(format,'new'))
              returnFileName = H_text2MotFileUmH36Mbm_wtnn(inputFileName, strPath, savePath);
            else
              returnFileName = H_text2MotFileUmH36Mbm(inputFileName, strPath, savePath);
            end
        end
 end
end

%%
% while(true)
%     [pName rem] = strtok(rem,  '\');
%     if(strcmp(rem, '\'))
%         break;
%     end
% end