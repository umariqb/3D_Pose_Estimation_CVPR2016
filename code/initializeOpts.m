function [opts skel] = initializeOpts(varargin)
%% The function initialize the options for different datasets, jointsets, and 
% other requried parameters. 
%% Hashim Yasin
%% most frequently used options

opts.loadInPath   = '../Data/';
opts.saveInPath   = '../Data/';

opts.inputDB      = 'Human36Mbm';                               % 'LeedSports'/'JHMDB'/'Human36Mbm'/HumanEva/Human80K/SynthVideo/KinectVideos/GoPro/
opts.database     = 'Human36Mbm';                               % 'HumanEva_regFit'/'CMU_30'/'HumanEva_H36M'/ 'CMU_H36M'/'Human36Mbm'/ 'Human80K'/'HumanEva'/CMU_amc_regFit/'HDM05_amc'/'HDM05_c3d'/'CMU_amc'/'CMU_c3d'/;
opts.inpType      = 'pgUmar';                                   % 'pgUmar'/'pgIlya'/GroundTruth
opts.actName      = '';                                 % ''/'Walking_1_(C1)' / 'Jog_1_(C1)' / 'Gestures_1_(C1)'
opts.subject      = '';                                           % 'S1', 'S2', 'S3'
opts.bodyType     = 'pose';                                         % pose 14/upper 10/lower 6/left 8/right 8
[opts.action, r]  = strtok(opts.actName,  '_');
opts.round        = 1;
%--------------------------------------------------------------------------
if(strcmp(opts.database, 'HumanEva'))
    opts.exp      = 'Main'; % 'Main' / 'Action Removed' / 'Skel Change' / 'MoCap Comp'
end
%--------------------------------------------------------------------------
opts.inputFormat  = 'Video';                                          % Video/Images
opts.strExt       = '.mat';
opts.dbSampling   = 'no';                                             % 'yes/no'
opts.projType     = 'Orthographic';                                   % 'Orthographic'/'Perspective'
opts.method       = '2Dvideo';                                        % 3D/2Dsyn/2Dvideo
opts.algo         = 'PG';                                             % MoP = Mixture of Parts/PG = Prof Gall/GT = GroundTruth
opts.lng          = 0;                                                % true / false
opts.qknn         = 2^12 ;               %                            % 256 / 128 / 64
opts.knn          = 256;  %128                                        % 256 / 128 / 64
opts.errType      = '3D-pose-error';                                  % 3D-error/3D-relerror/3D-pose-error/3D-relpose-error
opts.distortion   = 'alreadyDone';
%% varargin info
switch opts.inputDB
    case {'JHMDB','LeedSports'}
        if(nargin > 0)
            opts.bodyType    = varargin{1};
        end
    case 'Human36Mbm'
        if(nargin > 0)
            opts.projType    = varargin{1};
        end
        if(nargin > 1)
            opts.knn         = varargin{2};
        end
        if(nargin > 2)
            opts.bodyType    = varargin{3};
        end
        if(nargin > 3)
            opts.subject    = varargin{4};
        end
        if(nargin > 4)
            opts.round      = varargin{5};
        end
        if(nargin > 5)
           opts.inputDB     = varargin{6}; 
        end
        if(nargin > 6)
           opts.inpType     = varargin{7}; 
        end
        if(nargin > 7)
            opts.actName    = varargin{8};
        end
        if(nargin > 8)
           opts.loadInPath  = varargin{9}; 
        end
        if(nargin > 9)
           opts.saveInPath  = varargin{10}; 
        end
    case 'Human80K'
        if(nargin > 0)
            opts.bodyType    = cell2mat(varargin{1});
        end
    case 'HumanEva'
        if(nargin > 0)
            opts.subject     = cell2mat(varargin{1});
        end
        if(nargin > 1)
            opts.actName     = [cell2mat(varargin{2}) '_(C1)'];
            [opts.action, r] = strtok(opts.actName,  '_');
        end
        if(nargin > 2)
            opts.projType    = varargin{3};
        end
        if(nargin > 3)
            opts.knn         = varargin{4};
        end
        if(nargin > 4)
            opts.bodyType    = varargin{5};
        end
end
%% joints info
if(strcmp(opts.inputDB, 'HumanEva'))
    opts.sub         = str2double(opts.subject(2));
    [~, rem]         = strtok(opts.actName,  '(');
    opts.pathCalFile = fullfile(['D:\Work\HumanEva\' opts.subject '\Calibration_Data\' rem(2:3) '.cal']);
%    skel             = readASF('D:\Work\HumanEva\HumanEvaAMC\S2\Mocap_Data\LS.asf');
     skel = 1;
elseif(strcmp(opts.inputDB, 'Human80K'))
    small_4000; % config file
    opts.camera = camera;
end

opts.cJno     = getShapeJointNum(opts.bodyType,opts.inputDB);
[opts.allJoints, opts.cJoints] = getJointsHE (opts.inputDB,opts.database,opts.cJno,opts.bodyType);
opts          = getJointsIdx(opts);

%% paths
switch opts.inputDB
%==========================================================================
    case 'LeedSports'
        switch opts.database
            case {'CMU_30','CMU_amc_regFit'}
                switch opts.inpType
                    case 'GroundTruth'
                        opts.loadInPath  = fullfile('D:\Work\LeedSports\GT\');
                    case 'pgUmar'
                        if(opts.round == 1)
                            opts.loadInPath   = fullfile('D:\Work\LeedSports\Derived Poses\r1\');
                            %%%opts.loadInPath   = fullfile('D:\Work\LeedSports\Derived Poses\Rebuttelr1\');
                        elseif(opts.round == 2)
                            %%%opts.loadInPath   = fullfile('D:\Work\LeedSports\Derived Poses\r2\');
                        end
                end
        end
        opts.pLoadGT     = fullfile('D:\Work\LeedSports\GT\');
        opts.pathMain    = fullfile('D:\Work\LeedSports\');
        svStr            = '\umR';
        opts.actName     = 'LeedSports';
        opts.subject     = 'Sall';
        opts.loadPathDB  = fullfile([opts.pathMain 'Databases\']);
        skel  = 0;
%==========================================================================
    case 'JHMDB'
        switch opts.database
            case 'CMU_30'
                switch opts.inpType
                    case 'GroundTruth'
                        opts.loadInPath  = fullfile('');
                    case 'pgUmar'
                        if(opts.round == 1)
                            opts.loadInPath   = fullfile('D:\Work\JHMDB\Derived Poses\JHMDB\');
                        elseif(opts.round == 2)
                        end
                end
        end
        opts.pLoadGT     = fullfile('D:\Work\JHMDB\GT\');
        opts.pathMain    = fullfile('D:\Work\JHMDB\');
        svStr            = '\umR';
        opts.actName     = [opts.actName '_split_1'];
        opts.subject     = 'Sall';
        opts.loadPathDB  = fullfile([opts.pathMain 'Databases\']);
        skel  = 0;
%==========================================================================
    case 'Human36Mbm' 
        switch opts.database
            case 'Human36Mbm'
                switch opts.inpType
                    case 'GroundTruth'
                        %opts.loadInPath  = fullfile('/tmp/PE_Data');
                    case 'pgUmar'
                        if(opts.round == 1)
                            %opts.loadInPath  = fullfile('/tmp/PE_Data');
                        elseif(opts.round == 2)
                            %opts.loadInPath  = fullfile('/tmp/PE_Data');
                        end
                end
            case 'CMU_H36M'
                if(opts.round == 1)
                    %opts.loadInPath  = fullfile('/tmp/PE_Data');
                elseif(opts.round == 2)
                    %opts.loadInPath  = fullfile('/tmp/PE_Data');
                end
            otherwise
                disp('H-error: please specify correct mocap database ... ');
        end
% % %         opts.pLoadGT     = fullfile('D:\Work\Human36Mbm\GT\');
% % %         opts.pathMain    = fullfile('D:\Work\Human36Mbm\');
        svStr            = '\umR';
        
        if(isempty(opts.actName))
            opts.actName = 'Activity_All_C2';
        end
        if(isempty(opts.subject))
            opts.subject = 'S11';
        end
% % %         opts.loadPathDB  = fullfile([opts.pathMain 'Databases\']);
        skel  = 0;
    case 'HumanEva' 
        switch opts.inpType
            case 'pgIlya'
                opts.loadInPath  = fullfile('../HumanEva/Derived Poses/4th/3D/');
            case 'pgUmar'
                switch opts.database                    
                    case 'HumanEva_H36M'
                        if(opts.round == 1)                            
                            opts.loadInPath  = fullfile('../Data/');
                        elseif(opts.round == 2)                            
                        end                        
                end
         end
        opts.pathMain    = fullfile('../Data/HumanEva/');
        svStr            = '\umR';
    otherwise
        disp('H-error: please select database ... ');
end
%==========================================================================
%-------------------------------------------------------------------------- gt Save path
% opts.pathGT      = fullfile([opts.pathMain 'GT\']);
% if(~exist(opts.pathGT,'dir'))
%     mkdir(opts.pathGT)
% end
% %-------------------------------------------------------------------------- input Save path
% opts.pathIn      = fullfile([opts.pathMain 'Inputs\']);
% if(~exist(opts.pathIn,'dir'))
%     mkdir(opts.pathIn)
% end
%-------------------------------------------------------------------------- Save path
token            = textscan(opts.loadInPath, '%s', 'delimiter', '\\');
% opts.saveResPath = fullfile('E:\Work\Results\Retrieval\Rebuttel\');

%opts.saveResPath = fullfile('/tmp/PE_SaveResults');
% opts.saveResPath = fullfile([opts.saveResPath opts.inputDB '_' opts.database svStr num2str(opts.round) '\']);
% opts.saveResPath = fullfile([opts.saveResPath  cell2mat(token{end}(end)) '\sepOrient\']);
% opts.saveResPath = fullfile([opts.saveResPath opts.actName '_' opts.bodyType '\']);


%%
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


end







