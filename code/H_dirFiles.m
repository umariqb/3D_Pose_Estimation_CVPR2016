function H_dirFiles
% strPath  = 'F:\Work\HumanEva\Derived Poses\1st\2D\';
%  strPath = 'F:\Work\HumanEva\Derived Poses\1st\3D\';
% strPath = 'F:\Work\HumanEva\Derived Poses\2nd\';
% strPath = 'F:\Work\HumanEva\Derived Poses\3rd\';
 strPath = '../Data/';
token    = textscan(strPath, '%s', 'delimiter', '\\');

dirFiles = dir(strPath);
endVal = length(dirFiles);

for i=1:endVal
    [tmpName rem] = strtok(dirFiles(i).name,  '.');
    if (strcmp(rem,'.txt' ))
         if (strcmp(token{1}(end,1), '3D'))
             dimInfo = 3;  % 2 or 3
         else
             dimInfo = 2;  % 2 or 3
         end
%       fileNames{k} = sprintf('%s',dirFiles(i).name);
%       H_text2Mat(dirFiles(i).name, strPath,dimInfo);
        H_text2MotFile(dirFiles(i).name, strPath,dimInfo);
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