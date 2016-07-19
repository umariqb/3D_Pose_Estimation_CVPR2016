function obj = optimTransObj2MotInPerspSep(opts,obj,motIn,varargin)

addVideo = 'yes';
vidType  = 'image';      % 'video'/'image'
debug    = 0;            % 
if(~isfield(obj, 'bodyType'))
    obj.bodyType = opts.bodyType;
end

if(nargin>3)
    strOptm = varargin{1};
    if(size(varargin,2) == 2), addVideo = varargin{2};end;
end
loadPath = fullfile('D:\Work\HumanEva\');
loadPath = fullfile([loadPath opts.subject '\Image_Data\']);

%%
if (debug)
    if(strcmp(vidType,'video'))
        %------------------------------------------------------------------ Reading Video
        loadPath = fullfile('D:\Work\HumanEva\');
        loadPath = fullfile([loadPath opts.subject '\Image_Data\']);
        try
            vPath = [loadPath opts.actName '.avi' ];
            vFile = VideoReader(vPath);
        catch
            vPath = [loadPath opts.actName '.mp4' ];
            vFile = VideoReader(vPath);
        end
    else
        %------------------------------------------------------------------ Reading Images which are already distorted
        
         vFile = fullfile('D:\Work\Human36Mbm\GT\S11_im\');
 
     end
end

%% mot projection
switch opts.inputDB
    case {'JHMDB','LeedSports'}
        inp2d    = cell2mat(motIn.jointTrajectories2D);
        inp2d(2:2:end) = -inp2d(2:2:end);
    case {'Human80K','Human36Mbm'}
        inp2d    = cell2mat(motIn.jointTrajectories2DF);
    case 'HumanEva'
        [fc, cc, alpha_c, kc, Rc_ext, omc_ext, Tc_ext] = readSpicaCalib(opts.pathCalFile);
        omc_ext = zeros(3,1);
        Tc_ext  = zeros(3,1);
        if(strcmp(opts.inpType,'pgIlya'))
            n = 1;
            for t = 1:motIn.njoints
                tmpJ      = motIn.jointTrajectories{t}(:,:);% + repmat(Tr,1,mot.nframes);
                motIn.jointTrajectories2D{t,1}(n:n+1,:) = H_project_points2(tmpJ,omc_ext,Tc_ext,fc,cc,kc,alpha_c);
                motIn.jointTrajectories2D{n}(2,:)       = - motIn.jointTrajectories2D{n}(2,:);
            end
            inp2d    = cell2mat(motIn.jointTrajectories2D);
            [~, rootP2D] = H_getRootTranslationHE2D(motIn,opts);
        else
            inp2d    = cell2mat(motIn.jointTrajectories2DF);
        end
    otherwise
        disp('H-error: please specify inputDB in function H_optimTransObj2MotInPerspSep ... ');
end

%% Optimization
%-------------------------------------------------------------------------- all knn simultaneously
if(strcmp(opts.inputDB,'Human36Mbm'))
    cm = motIn.camera;
    opts.act = motIn.activityFrNum(:,1);
elseif(strcmp(opts.inputDB,'Human80K'))
    cm = motIn.camera;
    opts.bb = motIn.gtbbox;
elseif(strcmp(opts.inputDB,'HumanEva'))
    [cm.fc, cm.cc, cm.alpha_c, cm.kc, cm.Rc_ext, cm.omc_ext, cm.Tc_ext] = readSpicaCalib(opts.pathCalFile);
    cm.distortion = opts.distortion;
end
if(exist('obj','var'))
    %DEBUG INFORMATION: IF SINGLE IMAGE IS USED size(obj.data,2) is always
    %one -> knnPos is nxmx1 -> nxm 
    knnPos     = reshape(obj.data,3*length(obj.knnJoints),obj.knn,size(obj.data,2)); 
    single     =  0;
    if(size(obj.data,2) == 1)
        single = 1;
    end
    
    switch(opts.inputDB)
        case 'Human36Mbm'
            if(debug)
                [est2dRt, est3dRt, X] = optimCamMtxPerspSepWinH30Mbm(inp2d,knnPos,cm,opts, single,vFile);
                %%%[est2dRt, est3dRt, X] = optimCamMtxPerspSepWin(inp2d,knnPos,cm,opts);  
            else
                [est2dRt, est3dRt, X] = optimCamMtxPerspSepWinH30Mbm(inp2d,knnPos,cm,opts, single);
                %%%[est2dRt, est3dRt, X] = optimCamMtxPerspSepWin(inp2d,knnPos,cm,opts); 
            end
        case 'HumanEva'
            if(debug)
                %%%[est2dRt, est3dRt, X] = optimCamMtxPerspSepWinH30Mbm(inp2d,knnPos,cm,opts);
                [est2dRt, est3dRt, X] = optimCamMtxPerspSepWin(inp2d,knnPos,cm,opts);  
            else
                %%%[est2dRt, est3dRt, X] = optimCamMtxPerspSepWinH30Mbm(inp2d,knnPos,cm,opts);
                [est2dRt, est3dRt, X] = optimCamMtxPerspSepWin(inp2d,knnPos,cm,opts); 
            end
    end
    obj.proj2D = reshape(est2dRt,2*length(obj.knnJoints),obj.knn,size(obj.data,2));
    fprintf('\b');
    obj.data = est3dRt;
end


