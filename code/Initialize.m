%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Initializes all necessary PATHs and parameters    %%%%%%%%%%
%%%%%%%%%% Authors: Hashim Yasim, Umar Iqbal, Andreas Döring %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fprintf('Starting Initialization...\n');
    %% Setting up environment and paths
    addpath(fullfile('../code'));
    addpath(genpath(fullfile('../Human36M/code-v1.1/Release-v1.1')));       % paths for code for Human3.6M

    addpath(genpath(fullfile('../tools_intern')));
    addpath(genpath(fullfile('../tools')));
    addpath(genpath(fullfile('../MEX')));


    %% Add Library Paths
    OPENCV_LIBRARY_PATH = '/home/ibal_109/opencv-2.4.8/build/lib/:';
    OPENCV_INCLUDE_PATH = '/home/ibal_109/opencv-2.4.8/build/include/:';
    currentDir = pwd;
    TDPoseDir = '../MEX/src/eval_pose_human36m_multiscale';
    PoseRefinementDir = '../MEX/src/eval_pose_human36m_bestscale_with_nn_and_assign_weights';

    cd(TDPoseDir);
    p = getenv('LD_LIBRARY_PATH');
    p = [OPENCV_LIBRARY_PATH pwd ':' p];          % In some cases, Matlab 
                                                  % tends to use it's own 
                                                  % opencv libraries
                                                  % this leads to errors
                                                  % while executing mex
                                                  % files. Therefore the
                                                  % LD_LIBRARY_PATH is
                                                  % adapted
    setenv('LD_LIBRARY_PATH', p);

    p = getenv('PATH');
    p = [OPENCV_INCLUDE_PATH pwd ':' p];
    setenv('PATH', p);
    cd(currentDir);

    cd(PoseRefinementDir);
    p = getenv('LD_LIBRARY_PATH');
    p = [pwd ':' p];
    setenv('LD_LIBRARY_PATH', p);
    cd(currentDir);



    %% Define Config Paths and Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adapt those variables to their specific path                            %
    % TDPose_ConfigPath: /some/location/3D_Pose_Estimation/MEX/src/regressors %
    % TDPose_ExperimentName: folder contained in TDPose_ConfigPath            %
    % TDPose_ImgIndexPath: path to the test annotation file for the dataset   %
    % TDPose_NTrees: number of trees that are used in each forest             %
    % TDPose_TrainFile: Path to the train annotation file for the dataset     %
    % TDPose_TmpFileSavePath: Path where to save temporary data               %
    % TDPose_TmpSaveResults: Path where to save (temporary) results           %
    % TDPose_VisualizeResults: 1, if results should be visualized             %
    % TDPose_PauseAfterResult: 1, if estimation should be paused              %
    % TDPose_DeleteFilesAfterEstimation: delete all estimation files          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    TDPose_ConfigPath                       = '../MEX/src/regressors';
    TDPose_ExperimentName                   = 'regress_02';
    TDPose_TestImageLocation                = '../S11_im';
    TDPose_NTrees                           = uint32(30);
    TDPose_TrainFile                        = '../Data/image_index_train_rescaled.txt';
    TDPose_TmpFileSavePath                  = '/tmp/PE_Data2/';
    TDPose_TmpSaveResults                   = '/tmp/PE_SaveResults2/';
    TDPose_EstiamtedAnnotationName          = 'estimatedPose_human36m_multiscale_6s.txt';
    TDPose_RefinedEstimationFile            = 'ActivityAll_S11_C2_refined.txt';
    TDPose_ImgIndexPath                     = [TDPose_TmpFileSavePath 'image_index_path_test.txt'];
    TDPose_DeleteFilesAfterEstimation       = 1;
    TDPose_VisualizeResults                 = 1;
    TDPose_PauseAfterResult                 = 0;
    %% Initialize Opts
    opts.loadInPath   = TDPose_TmpFileSavePath;                   
    opts.saveInPath   = TDPose_TmpSaveResults;                     
    opts.loadPath     = '../Data/';
    opts.loadIdxPath  = '../Data/';
    opts.inputDB      = 'Human36Mbm';                                       % 'LeedSports'/'JHMDB'/'Human36Mbm'/HumanEva/Human80K/SynthVideo/KinectVideos/GoPro/
    opts.database     = 'Human36Mbm';                                       % 'HumanEva_regFit'/'CMU_30'/'HumanEva_H36M'/ 'CMU_H36M'/'Human36Mbm'/ 'Human80K'/'HumanEva'/CMU_amc_regFit/'HDM05_amc'/'HDM05_c3d'/'CMU_amc'/'CMU_c3d'/;
    opts.inpType      = 'pgUmar';                                           % 'pgUmar'/'pgIlya'/GroundTruth
    opts.actName      = '';                                                 % ''/'Walking_1_(C1)' / 'Jog_1_(C1)' / 'Gestures_1_(C1)'
    opts.subject      = 'S11';                                              % 'S1', 'S2', 'S3'
    opts.bodyType     = 'pose';                                             % pose 14/upper 10/lower 6/left 8/right 8
    [opts.action, r]  = strtok(opts.actName,  '_');
    opts.round        = 1;
    opts.numRounds    = 1;
    
    opts.inputFormat  = 'Video';                                            % Video/Images
    opts.strExt       = '.mat';
    opts.dbSampling   = 'no';                                               % 'yes/no'
    opts.projType     = 'Orthographic';                                     % 'Orthographic'/'Perspective'
    opts.method       = '2Dvideo';                                          % 3D/2Dsyn/2Dvideo
    opts.algo         = 'PG';                                               % MoP = Mixture of Parts/PG = Prof Gall/GT = GroundTruth
    opts.lng          = 0;                                                  % true / false
    opts.qknn         = 2^12 ;                                              % 256 / 128 / 64
    opts.knn          = 256;                                                % 256 / 128 / 64
    opts.errType      = '3D-pose-error';                                    % 3D-error/3D-relerror/3D-pose-error/3D-relpose-error
    opts.distortion   = 'alreadyDone';
    opts.saveResPath  = fullfile(TDPose_TmpSaveResults);
    opts.cJno         = getShapeJointNum(opts.bodyType,opts.inputDB);
    [opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,opts.bodyType);
    opts              = getJointsIdx(opts);
    opts.dataFormat   = 'old';
    opts.bodyTypes    =  {'pose' 'upper' 'lower' 'left' 'right'};
    opts.exp          = 'nogt';                                             % nogt/gt2D/gt3D

    svStr            = '/umR';

    if(isempty(opts.actName))
        opts.actName = 'Activity_All_C2';
    end
    if(isempty(opts.subject))
        opts.subject = 'S11';
    end
    skel  = 0;
    token = textscan(opts.loadInPath, '%s', 'delimiter', '\\');

    if ~exist(opts.saveResPath,'dir')
        mkdir(opts.saveResPath);
    end
    if ~exist(opts.loadInPath,'dir')
        mkdir(opts.loadInPath);
    end
    if ~exist(opts.saveInPath,'dir')
        mkdir(opts.saveInPath);
    end

    % 3D_error/3D_pose_error/3D_relpose_error
    switch opts.method
        %--------------------------------------------------------------------------
        case '3D'
            switch opts.errType
                case '3D-error'
                    opts.discRot      = 1;
                    opts.sampling     = 0;
                case '3D-pose-error'
                    opts.discRot      = 1;
                    opts.sampling     = 0;
                case '3D-relerror'
                    opts.discRot      = 0;
                    opts.sampling     = 0;
                case '3D-relpose-error'
                    opts.discRot      = 0;
                    opts.sampling     = 0;
                otherwise
                    disp('Wrong error type options');
            end
            %--------------------------------------------------------------------------
        case '2Dvideo'
            switch opts.errType
                case '3D-error'
                    opts.discRot      = 1;
                    opts.sampling     = 1;
                case '3D-pose-error'
                    opts.discRot      = 1;
                    opts.sampling     = 1;
                case '3D-relerror'
                    opts.discRot      = 0;
                    opts.sampling     = 0;
                case '3D-relpose-error'
                    opts.discRot      = 0;
                    opts.sampling     = 0;
                otherwise
                    disp('Wrong error type options');
            end
    end
    fprintf('Data enter:       ');
    fprintf([opts.actName ', ' opts.subject ', ' opts.projType ', ' num2str(opts.knn) ', ' opts.bodyType  ', ' num2str(opts.round) '\n']);

%% Loading the Database
    disp('Database Loading ... ')
    dbName = 'db';
    fname  = ['../Data/' dbName '.mat'];
    if(exist(fname,'file'))
        load(fname);
    %    [db, opts] = H_getActorMotIDs(db,opts);
    else
        disp('H_error: File is not exist');
    end

    fprintf('\b done \n');
    fprintf('Database Size: (%i   %i) \n',size(db.pos,1),size(db.pos,2));

%% Creating image_index_file for given test images
createImageIndexPathFile(TDPose_TestImageLocation,TDPose_ImgIndexPath);
isInitialized = 1;
