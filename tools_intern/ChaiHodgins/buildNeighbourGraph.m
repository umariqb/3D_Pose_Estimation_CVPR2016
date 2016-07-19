function res = buildNeighbourGraph()

global VARS_GLOBAL;

res.control_joints = [4,9,20,27];
epsilon = 4*5;

FilesOrFolders = uipickfiles('FilterSpec',VARS_GLOBAL.DBPATH);
pause(0.5);

res.mat_euler           = [];
res.mat_euler_selected  = [];
res.mat_pos             = [];
res.mat_pos_selected    = [];
res.mat_quat            = [];
res.mat_quat_selected   = [];

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
                save(fullfile(pathstr,mat_filename), 'skel', 'mot');
            catch
                fprintf('\nCould not read file!');
            end
        end
        
        mot.rootTranslation 	= zeros(3,mot.nframes);
%         mot                     = fitRootOrientationsFrameWise(skel,mot);
        mot.rotationQuat{1}     = [ones(1,mot.nframes);zeros(3,mot.nframes)];
        mot.rotationEuler{1}    = zeros(size(mot.rotationEuler{1}));
        mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
        mot.boundingBox         = computeBoundingBox(mot);
        
        % --------------
        res.mat_pos             = [res.mat_pos cell2mat(mot.jointTrajectories)];
        res.mat_pos_selected    = [res.mat_pos_selected cell2mat(mot.jointTrajectories(res.control_joints))];
        res.mat_euler           = [res.mat_euler cell2mat(mot.rotationEuler)];
        res.mat_euler_selected  = [res.mat_euler_selected cell2mat(mot.rotationEuler(res.control_joints))];
%         res.mat_quat            = [res.mat_quat cell2mat(mot.rotationQuat)];
%         res.mat_quat_selected   = [res.mat_quat_selected cell2mat(mot.rotationQuat(res.control_joints))];
        % --------------
    end
end

nrOfFrames = size(res.mat_euler,2);
nrOfEntriesToCompute = (nrOfFrames^2-nrOfFrames)/2;

fprintf('\n\nTotal number of frames: \t\t\t\t %10.i\n',nrOfFrames);
fprintf('Size of adjacency matrix: \t\t\t\t %10.i (= %i^2)\n',nrOfFrames^2,nrOfFrames);
fprintf('Total number of entries to compute: \t %10.i\n',nrOfEntriesToCompute);

% neighbourGraph = sparse(nrOfFrames,nrOfFrames);
neighbourGraph = speye(nrOfFrames,nrOfFrames);

nrOfPrints  = 50;
printTicks  = round(nrOfFrames/nrOfPrints);

fprintf('Entries computed: \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t');
entriesComputed = 0;
tic
for i=2:nrOfFrames
    neighbourGraph = spdiags(...
                        (sum(abs(res.mat_euler_selected(:,1:end-i+1)-res.mat_euler_selected(:,i:end)))<epsilon)'...
                        ,1-i,neighbourGraph);
    entriesComputed = entriesComputed+nrOfFrames-i+1;
    if mod(i,printTicks)==0
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b %10.i\n',entriesComputed);
    end
end
res.timeForMatrixConstruction = toc;
fprintf('\b\b\b\b\b\b\b\b\b\b\b\b %10.i in %.2f seconds.\n',entriesComputed,res.timeForMatrixConstruction);

res.nrOfFrames = nrOfFrames;
res.neighbourGraph = max(neighbourGraph,neighbourGraph');

% % fprintf('Entries computed: \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t');
% % entriesComputed = 0;
% tic;
% for i=1:nrOfFrames-1
%     for j=i+1:nrOfFrames
%         neighbourGraph(i,j) = ...
%             mean(abs(res.mat_euler_selected(:,i)-res.mat_euler_selected(:,j)))<epsilon;
% %         entriesComputed = entriesComputed+1;
% %         if mod(entriesComputed,10000)==0
% %             fprintf('\b\b\b\b\b\b\b\b\b\b\b\b %10.i\n',entriesComputed);
% %         end
% %         fprintf('Computing neighbourGraph (%3.i)\n', entriesComputed/nrOfEntriesToCompute);
%     end
% end
% res.timeForMatrixConstruction = toc;
% % fprintf('\b\b\b\b\b\b\b\b\b\b\b\b %10.i in %.2f seconds.\n',entriesComputed,res.timeForMatrixConstruction);
% 
% res.nrOfFrames = nrOfFrames;
% res.neighbourGraph = max(neighbourGraph,neighbourGraph');
% % res.neighbourGraph = neighbourGraph;