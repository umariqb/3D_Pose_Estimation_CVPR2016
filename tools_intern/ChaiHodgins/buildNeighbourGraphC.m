function data = buildNeighbourGraphC()

global VARS_GLOBAL;

data.control_joints = [4,9,20,27,3,8,19,26];
data.control_joints = [4,9,20,27];

dofs = [3 0 3 1 2 1 0 3 1 2 1 3 3 3 3 3 3 2 3 1 1 2 1 2 2 3 1 1 2 1 2];

epsilon = 16;
epsilon = epsilon * sum(dofs(data.control_joints));

FilesOrFolders = uipickfiles('FilterSpec',VARS_GLOBAL.DBPATH);
pause(0.5);

euler_selected      = [];
data.pos            = [];
data.quat           = [];


for i=1:length(FilesOrFolders)
    if isdir(FilesOrFolders{i})
        files = dir(fullfile(FilesOrFolders{i},'*.amc'));
        pathstr = FilesOrFolders{i};
        nrOfFiles = length(files);
    else
        [pathstr, name, ext] = fileparts(FilesOrFolders{i});
        clear files;
        files(1).name = [name ext];
        nrOfFiles = 1;
    end
        
    for j=1:nrOfFiles
        fprintf('\nReading file %i / %i in directory %s...',j,nrOfFiles,pathstr);
        amc_filename = files(j).name;
        asf_filename = [amc_filename(1:6) '.asf'];
        mat_filename = [amc_filename '.mat'];

        h = fopen(fullfile(pathstr,mat_filename));
        if (h~=-1) 
            fclose(h);
            load(fullfile(pathstr,mat_filename), 'skel', 'mot');
        else
            try
                skel = readASF(fullfile(pathstr,asf_filename));
                mot = readAMC(fullfile(pathstr,amc_filename),skel);
                mot.jointTrajectories = forwardKinematicsQuat(skel,mot);
                save(fullfile(pathstr,mat_filename), 'skel', 'mot');
            catch
                fprintf('\nCould not read file!');
            end
        end
        
        mot                         = changeFrameRate(skel,mot,30);
        mot.rootTranslation         = zeros(3,mot.nframes);
        mot.rotationQuat{1}(1,:)    = 1;
        mot.rotationQuat{1}(2:4,:)  = 0;
        mot.jointTrajectories       = forwardKinematicsQuat(skel,mot);
%         mot                     = fitRootOrientationsFrameWise(skel,mot);
        
        % --------------
        data.pos        = [data.pos cell2mat(mot.jointTrajectories)];
        euler_selected  = [euler_selected cell2mat(mot.rotationEuler(data.control_joints))];
        data.quat       = [data.quat cell2mat(mot.rotationQuat(mot.animated))];
        % --------------
    end
end

euler_selected(euler_selected>180)      = euler_selected(euler_selected>180)-360;
euler_selected(euler_selected<-180)     = euler_selected(euler_selected<-180)+360;

nrOfFrames              = size(euler_selected,2);
nrOfEntriesToCompute    = (nrOfFrames^2-nrOfFrames)/2;

fprintf('\n\nTotal number of frames: \t\t\t\t %10.i\n',nrOfFrames);
fprintf('Size of adjacency matrix: \t\t\t\t %10.i (= %i^2)\n',nrOfFrames^2,nrOfFrames);
fprintf('Total number of entries to compute: \t %10.i\n',nrOfEntriesToCompute);

tic;
[data.nGraph.points,data.nGraph.offsets] = ngraphwrapper(euler_selected,epsilon);
data.timeForMatrixConstruction = toc;

data.nrOfFrames = nrOfFrames;