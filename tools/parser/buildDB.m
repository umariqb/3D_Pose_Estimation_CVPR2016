function res = buildDB(varargin)

% optional settings -------------------------------------------------------
origFrameRate   = 119.88;
minFrameNumber  = 30;%origFrameRate; % ensure that no motions shorter than minFrameNumber frames are chosen

% HINWEIS: ohne "Orig" sind das die Daten nach "fitRootOrientationsFrameWise"!
options.addPosOrig      = 1;
options.addPos          = 1; 
options.addVelOrig      = 1;
options.addVel          = 1;
options.addVelL         = 1;
options.addAccOrig      = 1;
options.addAcc          = 1;
options.addAccL         = 1;
options.addQuat         = 1;
options.addEuler        = 0;
options.addInvRootRot   = 1;
options.addDeltaRootPos = 1;
options.addDeltaRootOri = 1;
options.addOrigRootPos  = 1; % needed for extractMotFromDBmat
options.addOrigRootOri  = 1; % needed for extractMotFromDBmat
options.addSkel         = 1;
options.addSensorAccs   = 1; % calibrated based on t-pose assumed in first frame of motion
options.addMirrors      = 0;
options.correctWristOrientations = 1; % only affects lwrist and rwrist quats and thus velL and accL
options.addFootprints   = 0;

res_args = checkargins_local(varargin,origFrameRate);

global VARS_GLOBAL;

% Precomputing number of frames and files ---------------------------------
FilesOrFolders = uipickfiles();
pause(0.5);

fprintf('Precomputing total number of frames: \t\t\t\t\t\t');
[totalNrOfFrames,totalNrOfAMCFiles,totalNrOfMATFiles] = ...
    countFiles_local(FilesOrFolders,minFrameNumber,origFrameRate,res_args.newFrameRate);
fprintf(' ...finished.');

totalNrOfFiles = totalNrOfAMCFiles+totalNrOfMATFiles;

if totalNrOfMATFiles>0
    fprintf('\nTotal number of frames could not be computed because of missing amc-files.\n');
    fprintf('However, %i mat-files were found.\n',totalNrOfFiles);
    fprintf('Please enter number of FILES (Press Enter for %i): ',totalNrOfFiles);
    tmp = input('');
    if ~isempty(tmp),
        totalNrOfFiles = tmp; 
    else
        fprintf('\b%i\n',totalNrOfFiles);
    end
    fprintf('Please enter number of FRAMES (%i were counted in %i files): ',totalNrOfFrames,totalNrOfAMCFiles);
    totalNrOfFrames = input('');
    if isempty(totalNrOfFrames);
        totalNrOfFrames=1;
    end
end

if options.addMirrors
    totalNrOfFrames = 2*totalNrOfFrames;
    totalNrOfFiles = 2*totalNrOfFiles;
end

% -------------------------------------------------------------------------
if options.addPosOrig,          res.posOrig         = single(zeros(93,totalNrOfFrames));    end
if options.addPos,              res.pos             = single(zeros(93,totalNrOfFrames));    end
if options.addVelOrig,          res.velOrig         = single(zeros(93,totalNrOfFrames));    end
if options.addVel,              res.vel             = single(zeros(93,totalNrOfFrames));    end
if options.addVelL,             res.velL            = single(zeros(93,totalNrOfFrames));    end
if options.addAccOrig,          res.accOrig         = single(zeros(93,totalNrOfFrames));    end
if options.addAcc,              res.acc             = single(zeros(93,totalNrOfFrames));    end
if options.addAccL,             res.accL            = single(zeros(93,totalNrOfFrames));    end
if options.addQuat,             res.quat            = zeros(116,totalNrOfFrames);           end
if options.addEuler,            res.euler           = single(zeros(59,totalNrOfFrames));    end
if options.addInvRootRot,       res.invRootRot      = zeros(4,totalNrOfFrames);             end
if options.addDeltaRootPos,     res.deltaRootPos    = zeros(3,totalNrOfFrames);             end
if options.addDeltaRootOri,     res.deltaRootOri    = zeros(4,totalNrOfFrames);             end
if options.addOrigRootPos,      res.origRootPos     = zeros(3,totalNrOfFrames);             end
if options.addOrigRootOri,      res.origRootOri     = zeros(4,totalNrOfFrames);             end
if options.addSkel,             res.skels           = cell(totalNrOfFiles,1);               end
if options.addSensorAccs,        
    sensors         = defaultSensors();
    sensors         = fieldnames(sensors);
    nrOfSensors     = numel(sensors);
    res.sensorAccs  = cell2struct(mat2cell(zeros(nrOfSensors*3,totalNrOfFrames),ones(1,nrOfSensors)*3,totalNrOfFrames),sensors);
end
if options.addFootprints
   res.footprints      = false(2,totalNrOfFrames);
   res.dbAnnotation    = false(1,totalNrOfFiles);
   % Java class for communication with db server
   annoqpath     = fullfile('..','projects','dynamicMotionGraph','footprints','AnnotationQuery.jar');
   postgresspath = fullfile('..','projects','dynamicMotionGraph','footprints','postgresql-8.4-701.jdbc4.jar');
   javaaddpath   (annoqpath);
   javaaddpath   (postgresspath);
   
   import        AnnotationQuery.*
   aq          = AnnotationQuery();
end

res.motNames        = cell(totalNrOfFiles,1);
res.motStartIDs     = single(zeros(totalNrOfFiles,1));

% -------------------------------------------------------------------------
res.frameRate   = res_args.newFrameRate;

c     = 0;
frame = 1;

for i=1:length(FilesOrFolders)
    if isdir(FilesOrFolders{i})
        files       = dir(fullfile(FilesOrFolders{i},'*.amc'));
        if isempty(files), files = dir(fullfile(FilesOrFolders{i},'*.mat')); end
        asffiles    = dir(fullfile(FilesOrFolders{i},'*.asf'));
        pathstr     = FilesOrFolders{i};
        nrOfFiles   = length(files);
    else
        [pathstr, name, ext] = fileparts(FilesOrFolders{i});
        asffiles    = dir(fullfile(pathstr,'*.asf'));
        clear files;
        files(1).name = [name ext];
        nrOfFiles = 1;
    end
    
    asffiles    = arrayfun(@(x) x.name(1:end-4),asffiles,'UniformOutput',0);
    
    for j=1:nrOfFiles
        
        if strcmp(files(j).name(end-2:end),'mat')
            amc_filename = files(j).name(1:end-4);
        else
            amc_filename = files(j).name;
        end
        
        for f=1:size(asffiles,1)
            if findstr(asffiles{f},amc_filename)
                asf_filename = [asffiles{f} '.asf'];
                break
            end
        end
        mat_filename = [amc_filename '.mat'];

        h = fopen(fullfile(pathstr,mat_filename));
        if (h~=-1) 
            fclose(h);
            load(fullfile(pathstr,mat_filename), 'skel', 'mot');
        else
            try
                fprintf('\n');
                skel    = readASF(fullfile(pathstr,asf_filename));
                mot     = readAMC(fullfile(pathstr,amc_filename),skel);
                save(fullfile(pathstr,mat_filename), 'skel', 'mot');
                fprintf('Frames read: \t\t\t\t\t\t\t\t\t\t\t\t\t');
            catch
                fprintf('\nCould not read file!\n');
            end
        end
        
        mot.samplingRate    = origFrameRate;
        mot.frameTime       = 1/origFrameRate;
        
        if mot.nframes>=minFrameNumber

            if ~res_args.individualSkels
                skel = res_args.FixedSkel;
%                 mot.jointTrajectories = iterativeForwKinematics(skel,mot);
            elseif ~res_args.individualBoneLengths
                for k=1:numel(res_args.FixedBoneLengths)
                    skel.nodes(k).length = res_args.FixedBoneLengths(k);
                    skel.nodes(k).offset = skel.nodes(k).direction * res_args.FixedBoneLengths(k);
                end
%                 mot.jointTrajectories = iterativeForwKinematics(skel,mot);
            end
            
            mot = changeFrameRate(skel,mot,res_args.newFrameRate);
            
            
            
            for mm=1:1+options.addMirrors
                
                c = c+1;
                
                if mm==2
                    [skel,mot]      = mirrorMot(skel,mot); % mirrorMot does forward kinematics
                    res.motNames{c} = [amc_filename '.mirrored'];
                else
                    res.motNames{c} = amc_filename;
                end
                
                if options.correctWristOrientations
                    [mot,res_tmp] = correctOrientationsInMot(skel,mot);
                    mot.jointTrajectories = iterativeForwKinematics(skel,mot);
                end

                res.motStartIDs(c)  = frame;

                if options.addSkel
                    res.skels{c} = skel;
                end

                if options.addVelOrig, mot = addVelToMot(mot); end;
                if options.addAccOrig, mot = addAccToMot(mot); end;
                if options.addFootprints
                   [mot,res.dbAnnotation(j)] = detectFootprints(skel,mot,aq);
                end

                sf = frame;
                ef = frame+mot.nframes-1;

                if options.addPosOrig, res.posOrig(:,sf:ef) = cell2mat(mot.jointTrajectories);  end
                if options.addVelOrig, res.velOrig(:,sf:ef) = cell2mat(mot.jointVelocities);    end
                if options.addAccOrig, res.accOrig(:,sf:ef) = cell2mat(mot.jointAccelerations); end
                if options.addOrigRootPos, res.origRootPos(:,sf:ef) = mot.rootTranslation;      end
                if options.addOrigRootOri, res.origRootOri(:,sf:ef) = mot.rotationQuat{1};      end
                if mm==1
                    if options.addFootprints,  res.footprints(:,sf:ef)  = mot.footprints;           end
                else
                    % mirror footprints
                    if options.addFootprints,  res.footprints(:,sf:ef)  = flipud(mot.footprints);           end
                end

                if options.addDeltaRootPos
                    t1 = mot.rootTranslation(:,1:end-1);
                    t2 = mot.rootTranslation(:,2:end);
                    res.deltaRootPos(:,sf:ef) = [ [0;0;0] C_quatrot(t2-t1,C_quatinv(mot.rotationQuat{1}(:,2:end)))];
                end
                if options.addDeltaRootOri
                    q1 = mot.rotationQuat{1}(:,1:end-1);
                    q2 = mot.rotationQuat{1}(:,2:end);
                    res.deltaRootOri(:,sf:ef) = [[1;0;0;0] C_quatmult(C_quatinv(q1),q2)];
                end
                
                if options.addPos || options.addVel || options.addAcc || options.addQuat || options.addEuler || options.addAccL || options.addVelL
                    mot0 = mot;
                    mot0.rootTranslation(:,:)    = 0; 
                    [mot0,qy,~,q_L2G] = fitRootOrientationsFrameWise(skel,mot0);
                    
                    if options.addInvRootRot
                        res.invRootRot(:,sf:ef) = qy;
                    end

                    if options.addPos
                        res.pos(:,sf:ef)    = cell2mat(mot0.jointTrajectories);
                    end
                    
                    if options.addVelL || options.addAccL
                        q_G2L = cellfun(@(x) C_quatinv(x),q_L2G,'UniformOutput',0);
                    end
                    
                    if options.addVel || options.addVelL
                        mot0                  = addVelToMot(mot0);
                        if options.addVel
                            res.vel(:,sf:ef)  = cell2mat(mot0.jointVelocities);
                        end
                        if options.addVelL
                            res.velL(:,sf:ef) = cell2mat(cellfun(@(x,y) C_quatrot(x,y),mot0.jointVelocities,q_G2L,'UniformOutput',0));
                        end
                    end
                    if options.addAcc || options.addAccL
                        mot0                 = addAccToMot(mot0);
                        if options.addAcc
                            res.acc(:,sf:ef) = cell2mat(mot0.jointAccelerations);
                        end
                        if options.addAccL
                            res.accL(:,sf:ef) = cell2mat(cellfun(@(x,y) C_quatrot(x,y),mot0.jointAccelerations,q_G2L,'UniformOutput',0));
                        end
                    end
                    
                    if options.addEuler
                        mot0                = convert2euler(skel,mot0);
                        res.euler(:,sf:ef)  = real(cell2mat(mot0.rotationEuler(mot0.animated)));
                    end
                    if options.addQuat
                        res.quat(:,sf:ef)   = cell2mat(mot0.rotationQuat(mot0.animated));
                    end
                end

                if options.addSensorAccs
                    if ~options.correctWristOrientations || mm==2
                        res_tmp = simulateLocalAccsFromAMC2(skel,mot);
                    end
                    for s=1:nrOfSensors
                        res.sensorAccs.(sensors{s})(:,sf:ef) = res_tmp.(sensors{s}).acc_L;
                    end
                end

                frame = frame + mot.nframes;

                fprintf('\b\b\b\b\b\b\b%7i',frame-1);
            end
        end
    end
end

if options.addFootprints
   % delete Java object
   clear('aq');
end

fprintf(' ...finished.\n');

if frame-1<totalNrOfFrames || c<totalNrOfFiles
    res = cleanup_local(res,totalNrOfFiles,c,totalNrOfFrames,frame-1);
    res.nrOfFrames = frame-1;
else
    res.nrOfFrames = frame-1;
end

end

%% local functions
function db = cleanup_local(db,totalNrOfFiles,actualNrOfFiles,totalNrOfFrames,actualNrOfFrames)

    % if c~=totalNrOfFiles
    %     res.motNames = res.motNames(1:c);
    %     res.motStartIDs = res.motStartIDs(1:c);
    % end
    
%     totalNrOfFrames = db.nrOfFrames;
%     totalNrOfFiles  = numel(db.motStartIDs);

%     mots2keep   = 1:actualNrOfFiles;
%     frames2keep = 1:actualNrOfFrames;
    fields = fieldnames(db);
    for f=1:size(fields,1)

        field = fields{f};

        [a,b]=ismember([totalNrOfFiles,totalNrOfFrames],size(db.(field)));

        if all(a)
            fprintf('Caution: Field %s is of ambiguous size. Please remove values manually.\n',field);
        elseif a(1)
            if b(1)==1
%                 db.(field)=db.(field)(mots2keep,:);
                db.(field)(actualNrOfFiles+1:end,:) = [];
            elseif b(1)==2
                db.(field)(:,actualNrOfFiles+1:end) = [];
%                 db.(field)=db.(field)(:,mots2keep);
            end
        elseif a(2)
            if b(2)==1
                db.(field)(actualNrOfFrames+1:end,:) = [];
%                 db.(field)=db.(field)(frames2keep,:);
            elseif b(2)==2
                db.(field)(:,actualNrOfFrames+1:end) = [];
%                 db.(field)=db.(field)(:,frames2keep);
            end
        elseif isstruct(db.(field))
            db.(field) = cleanup_local(db.(field),totalNrOfFiles,actualNrOfFiles,totalNrOfFrames,actualNrOfFrames);
        end

    end

end

function isskel = isSkel_local(var)
    isskel = isstruct(var) && all(isfield(var,{'njoints','nodes'}));
end

function isframerate = isFrameRate_local(var)
    isframerate = isnumeric(var) && numel(var)==1;
end

function isbonelengthsarray = isBoneLengthsArray_local(var)
    isbonelengthsarray = isnumeric(var) && numel(var)==31;
end

function [totalNrOfFrames,totalNrOfAMCFiles,totalNrOfMATFiles] = countFiles_local(FilesOrFolders,minFrameNumber,origFrameRate,newFrameRate)

    totalNrOfFrames = 0;
    totalNrOfAMCFiles = 0;
    totalNrOfMATFiles = 0;
    
    for i=1:length(FilesOrFolders)
        if isdir(FilesOrFolders{i})
            files = dir(fullfile(FilesOrFolders{i},'*.amc'));
            nrOfAMCFiles = numel(files);
            if nrOfAMCFiles==0
                nrOfMATFiles = numel(dir(fullfile(FilesOrFolders{i},'*.mat')));
            else
                nrOfMATFiles = 0;
            end
            pathstr     = FilesOrFolders{i};
        else
            [pathstr, name, ext] = fileparts(FilesOrFolders{i});
            
            if strcmp(ext,'.amc') 
                nrOfAMCFiles = 1;
                nrOfMATFiles = 0;
                clear files;
                files(1).name = [name ext];
            elseif strcmp(ext,'.mat'), 
                if numel((dir(fullfile(pathstr,name))))>0
                    clear files;
                    files(1).name = name;
                    nrOfAMCFiles = 1;
                    nrOfMATFiles = 0;
                else
                    nrOfMATFiles = 1;
                    nrOfAMCFiles = 0;
                end
            end
        end
        
        if nrOfAMCFiles>0
            for j=1:nrOfAMCFiles
                amc_filename    = fullfile(pathstr,files(j).name);
                nrOfFrames      = readNrOfFramesFromFile(amc_filename);
                if (nrOfFrames >= minFrameNumber) 
                    nrOfFrames      = numel(1:origFrameRate/newFrameRate:nrOfFrames);
                    totalNrOfFrames = totalNrOfFrames + nrOfFrames;
                    totalNrOfAMCFiles  = totalNrOfAMCFiles + 1;
                end
                fprintf('\b\b\b\b\b\b\b%7i',totalNrOfFrames);
            end
        else
            totalNrOfMATFiles = totalNrOfMATFiles + nrOfMATFiles; 
        end
    end
end

function res = checkargins_local(argins,origFrameRate)

    % Checking nargins --------------------------------------------------------
    switch numel(argins)
        case 0
            res.newFrameRate = origFrameRate;
            res.individualSkels = true;
        case 1
            if isSkel_local(argins{1})
                res.individualSkels         = false;
                res.individualBoneLengths   = false;
                res.FixedSkel               = argins{1};
            elseif isFrameRate_local(argins{1})
                res.individualSkels         = true;
                res.individualBoneLengths   = true;
                res.newFrameRate            = argins{1};
            elseif isBoneLengthsArray_local(argins{1})
                res.individualSkels         = true;
                res.individualBoneLengths   = false;
                res.FixedBoneLengths        = argins{1};
            else
                error('Wrong types of argins!');
            end
        case 2
            if isSkel_local(argins{1}) && isFrameRate_local(argins{2})
                res.individualSkels         = false;
                res.individualBoneLengths   = false;
                res.FixedSkel               = argins{1};
                res.newFrameRate            = argins{2};
            elseif isSkel_local(argins{2}) && isFrameRate_local(argins{1})
                res.individualSkels         = false;
                res.individualBoneLengths   = false;
                res.FixedSkel               = argins{2};
                res.newFrameRate            = argins{1};
            elseif isFrameRate_local(argins{1}) && isBoneLengthsArray_local(argins{2})
                res.individualSkels         = true;
                res.individualBoneLengths   = false;
                res.newFrameRate            = argins{1};
                res.FixedBoneLengths        = argins{2};
            elseif isFrameRate_local(argins{2}) && isBoneLengthsArray_local(argins{1})
                res.individualSkels         = true;
                res.individualBoneLengths   = false;
                res.newFrameRate            = argins{2};
                res.FixedBoneLengths        = argins{1};
            else
                error('Wrong types of argins!');
            end 
        otherwise
            error('Wrong number of argins!');
    end
end
