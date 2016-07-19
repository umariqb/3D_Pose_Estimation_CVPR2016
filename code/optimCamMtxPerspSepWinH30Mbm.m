function [est2dRt, est3dRt, X] = optimCamMtxPerspSepWinH30Mbm(inp2d,knn3d,cm,opts, singleDim, varargin)
if(nargin > 5)
    vFile = varargin{1};
end
if (exist('vFile','var'))
    if(~isobject(vFile))
        vFilePath = vFile;
    end
    testIm = 1;
    dirFiles       = dir([vFile '*.png']);
    drnm           = char(dirFiles.name);   % orginizing order
    drnmCell       = cellstr(drnm);
    drnmCell       = sort_nat(drnmCell);
else
    testIm = 0;
end
windowsize = 2;                                 % for 5 we have to select 4
optimOpts = optimset(...
    'Display','off',...                         % 'Display','iter'
    'MaxIter',10000,...
    'MaxFunEvals',10000,...                     %     'PlotFcns', @optimplotx, ...
    'Algorithm' ,'trust-region-reflective',...  %'levenberg-marquardt' , ...
    'TolX',0.001);
lb = []; ub = [];
%% Loading Camera matx already optimized and save previously
pload = '../Datatest/';
camLoad  = [pload opts.subject '_' opts.actName  '_' num2str(opts.knn) '_pose_camMtxdfgff.mat'];
if(exist(camLoad,'file'))
    load(camLoad);
end
if(exist('camMtx','var'))
    camMtxLoad = true;
else
    camMtxLoad = false;
    startValue = [0;0;0;0;0;0];
end
%%
%--------------------------------------------------------------------------%Loading cam mtx given
cam         = 2;  % cam = 1 optimal
Sequence    = H36MSequence(11, 1, 1, cam, 1);
obj         = Sequence.getCamera();
cm.R        = obj.R;
cm.T        = obj.T;
cm          = obj;

%%
nJoints    = length(opts.allJoints);

knn3dv =  knn3d(opts.cJidx3,:,:);
inp2dv =  inp2d(opts.cJidx2,:);

X      = cell(size(inp2d,2),1);
rn     = nan(size(inp2d,2),1);

% X2      = cell(size(inp2d,2),1);
% rn2     = nan(size(inp2d,2),1);
act = 1;
if((ndims(knn3d)==3) || (singleDim == 1))
    %% all knn simultaneously
    est2dRt    = nan(2*nJoints*opts.knn,size(inp2d,2));
    est3dRt    = nan(3*nJoints*opts.knn,size(inp2d,2));
    fprintf('Optimization: Frame no. ...   ');
    count = 1;
    tic
    rot = true;
    for f = 1:size(inp2d,2)
        fprintf('%5d ', f);
        %------------------------------------------------------------------% all 14 joints
        est3d    = H_regularize(knn3d,f);
        %------------------------------------------------------------------% optimize with selective joints (opts.cJoints)
        est3dv   = H_regularize(knn3dv,f);
        inp2dRev = reshape(inp2dv(:,f),2,[]);
        inp2dRev = repmat(inp2dRev,1,size(knn3d,2));
        %------------------------------------------------------------------% optimize and getting R,t parameters
        %startValue0 = [0;0;0;0;0;0];
        if(camMtxLoad)
            startValue = camMtx{f};
        end
% % %         if(act<opts.act(f))
% % %             startValue = [0;0;0;0;0;0];
% % %         end
        [X{count,1},rn(count,1)] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),startValue,lb,ub,optimOpts);
        %startValue = X{count,1};
% % %         if(startValue ~= [0;0;0;0;0;0])
% % %         if(rn(count,1) > 9.0e5)
% % %             startValue = [0;0;0;0;0;0];
% % %             [x2,rnn2] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),startValue,lb,ub,optimOpts);
% % %             if(rn(count,1) > rnn2)
% % %                  X{count,1} = x2;
% % %                  rn(count,1)= rnn2;
% % %             end
% % %          end
% % %         end
% % %         startValue = X{count,1};        
%         if(camMtxLoad)
%             startValue = camMtx{f};
%             [X2{count,1},rn2(count,1)] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),startValue,lb,ub,optimOpts);
%         end
%         if(rn2(count,1) < rn(count,1))
%             Xm      = X2{count,1};
%         else
%             Xm      = X{count,1};
%         end
        Xm              = X{count,1};
        %------------------------------------------------------------------
        [est2d,j3d]     = H_proj(Xm,est3d,cm);
        tm2d            = reshape(est2d,2*nJoints,[]);
        est2dRt(:,f)    = tm2d(:);
        %est3d(1,:)      = -est3d(1,:);
        j3d([2 3],:)    = flipud(j3d([2 3],:));
        tm3d            = reshape(j3d,3*nJoints,[]);
        est3dRt(:,f)    = tm3d(:);
        camMtx{count,1} = Xm;
        fprintf('\b\b\b\b\b\b');
        %%
        if(testIm)
            bodyType = opts.bodyType;
            if(~isobject(vFile))
                vFile = [vFilePath drnmCell{f}];
            end
            H_writeImageTest(opts,inp2d(:,f),est2dRt(:,f),vFile,f,bodyType)
        end
        %%
        count = count + 1;
        act = opts.act(f);
    end
    toc
end
camName  = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_camMtx.mat'];
save(fullfile(opts.saveResPath,camName),'camMtx','-v7.3');
end

function f = objfunLocal(x,in2d,est3d,cm)
[est2d,~] = H_proj(x,est3d,cm);

f      = sqrt(sum((est2d - in2d).^2));
%f      = norm(est2d - in2d,1);
% f = repmat(sum(sqrt(sqrt(sum((est2d - in2d).^2)))),size(x));

end
function [est2d,j3d] = H_proj(x,est3d,cm)
R      = makehgtform('xrotate',deg2rad(x(1)),'yrotate',deg2rad(x(2)),'zrotate',deg2rad(x(3)));
R      = R(1:3,1:3);
T      = [x(4); x(5); x(6)];
R      = [R T];
j3d    = R*est3d;

% T      = T';
% j3d    = est3d(1:3,:);
[est2d, ~] = ProjectPointRadial(j3d', cm.R, cm.T, cm.f, cm.c, cm.k, cm.p);
est2d = est2d';

end
function est3d = H_rotFlip(est3d,rot)
if(rot)
    %R   = makehgtform('xrotate',H_deg2rad(180));
    R   = makehgtform('xrotate',deg2rad(90));
    est3d = R * est3d;
end
end

function est3d = H_regularize(knn3d,f)
%%
est3d           = knn3d(:,:,f);
est3d           = squeeze(est3d);
est3d           = reshape(est3d,3,[]);
est3d([2 3],:)  = flipud(est3d([2 3],:));
%  est3d(2,:)      = -est3d(2,:);
est3d(1,:)      = -est3d(1,:); % used for h36m
est3d(4,:)      = 1;

end




