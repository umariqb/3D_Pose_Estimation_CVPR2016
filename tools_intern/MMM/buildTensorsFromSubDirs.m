function ALLTENSORS=buildTensorsFromSubDirs(path, varargin)
% Build Tensors: One for each subdirectory. Save all in a struct
% Give a path and optionaly if a cached Version can be loaded or not.
% Example: TENS=buildTensorsFromSubDirs('R:\HDM05_SmallDB\cut_amc',true);
% will recalculate all tensors. If true is not set, or set to false the
% calculation will just be started if there is no cached version.

%Check if optional paramter is given:
switch nargin
        case 1
            forceCalc=false(1);
            dataRep  ='Quat';
        case 2
            forceCalc=varargin{1};
            dataRep  ='Quat';
        case 3
            forceCalc=varargin{1};
            dataRep  =varargin{2};
        otherwise
            error('Wrong number of Args');
end

% Check if backslash is the end of the given path. Append one if
% necessary.
dim=size(path);
if(path(dim(2))~='\')
    path=[path '\'];
end

% Remove backslashs from filename.
pathm=strrep(path,':','');
file=strrep(pathm,'\','_');

matfile=[path file 'TENSORS_' dataRep '.mat'];

fprintf(['Datatype = ' dataRep '!\n']);

h=fopen(matfile);

if(h~=-1 && ~forceCalc)
    fclose(h);
    fprintf('Tensors will be loaded from File.\n');
    load(matfile,'ALLTENSORS');
else
    fprintf('Tensors will be calculated and saved to File.\n');
    oldPath=pwd;
    cd(path);
    content=dir;

    j=1;
    for i=3:size(content,1)
        fprintf(['Dir: ' content(i).name '\n']);
        if(content(i).isdir)
            ALLTENSORS{1,j}.Path=strcat(path,content(i).name);
            ALLTENSORS{1,j}=buildTensorFromDir2(strcat(path,content(i).name),3,dataRep);
            ALLTENSORS{1,j}=HOSVD(ALLTENSORS{1,j});
            ALLTENSORS{2,j}=content(i).name;
             j=j+1;
        end
    end
    save(matfile,'ALLTENSORS');
    cd(oldPath);
end
