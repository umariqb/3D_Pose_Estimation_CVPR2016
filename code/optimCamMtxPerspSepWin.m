function [est2dRt, est3dRt, X] = optimCamMtxPerspSepWin(inp2d,knn3d,cm,opts,varargin)
%% Hashim Yasin
strtOp     = 1;
windowsize = 4;   % for 5 we have to select 4

if(nargin > 4)
    vFile = varargin{1};
end
if (exist('vFile','var'))
    testIm = 1;
else
    testIm = 0;
end

optimOpts = optimset(...
    'Display','off',...           % 'Display','iter'
    'MaxIter',10000,...
    'MaxFunEvals',10000,...  %     'PlotFcns', @optimplotx, ...
    'Algorithm' , 'trust-region-reflective' , ...%'trust-region-reflective',... %'levenberg-marquardt' , ...
    'TolX',0.001);
startValue = [0;0;0;0;0;0];

lb = []; ub = [];
nJoints    = length(opts.allJoints);

knn3dv =  knn3d(opts.cJidx3,:,:);
inp2dv =  inp2d(opts.cJidx2,:);

% idx2   = H_getSingleJntIdx({'Head';'Left Shoulder'; 'Right Shoulder'; 'Left Hip'; 'Right Hip'; 'Neck'},2,opts.allJoints);
% idx3   = H_getSingleJntIdx({'Head';'Left Shoulder'; 'Right Shoulder'; 'Left Hip'; 'Right Hip'; 'Neck'},3,opts.allJoints);
% knn3dv =  knn3d(idx3,:,:);
% inp2dv =  inp2d(idx2,:);
cnt = 0;
if(ndims(knn3d)==3)
    %% all knn simultaneously
    %---------------------------------------------------------------------- starting options
    if(strtOp)
        fprintf('Initialization Step: ...   ');
        c = 1;
        for s = 1:10
            optimOpts2 = optimset(...
                'Display','off',...           % 'Display','iter'
                'MaxIter',10000,...
                'MaxFunEvals',10000,...  %     'PlotFcns', @optimplotx, ...
                'Algorithm' , 'levenberg-marquardt' , ...%'trust-region-reflective',... %'levenberg-marquardt' , ...
                'TolX',0.001);
            lb2         = [0,0,0,-10000,-10000,-10000];
            ub2         = [360,360,360,10000,10000,10000];
            est3dv   = H_regularize(knn3d,s);
            inp2dRev = reshape(inp2d(:,s),2,[]);
            inp2dRev = repmat(inp2dRev,1,size(knn3d,2));
            [Xt{c,1},rnt(c,1)] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),startValue,lb2,ub2,optimOpts2);
            startValue   = Xt{c,1};
            c = c + 1;
        end
        [~,ind]    = min(rnt(:));
        startValue = Xt{ind,1};
    end
    %----------------------------------------------------------------------
    est2dRt    = nan(2*nJoints*opts.knn,size(inp2d,2));
    est3dRt    = nan(3*nJoints*opts.knn,size(inp2d,2));
    fprintf('Optimization: Frame no. ...   ');
    tic
    for f = 1:size(inp2d,2)
        fprintf('%3d ', f);
        %------------------------------------------------------------------% all 14 joints
        est3d    = H_regularize(knn3d,f);
        %       inp2dRe  = reshape(inp2d(:,f),2,[]);,
        %       inp2dRe  = repmat(inp2dRe,1,size(knn3d,2));
        %------------------------------------------------------------------% optimize with selective joints (opts.cJoints)
        est3dv   = H_regularize(knn3dv,f);
        inp2dRev = reshape(inp2dv(:,f),2,[]);
        inp2dRev = repmat(inp2dRev,1,size(knn3d,2));
        %------------------------------------------------------------------% optimize and getting R,t parameters
        [X{f,1},rn(f,1)] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),startValue,lb,ub,optimOpts);
        %------------------------------------------------------------------% starting options
        if(f == 1)
            rnFr = 0;
            while(rn>3e+05)
                [X{f,1},rn(f,1)] = lsqnonlin(@(x) objfunLocal(x,inp2dRev,est3dv,cm),X{f,1},lb,ub,optimOpts);
                if (rnFr == rn)
                    break;
                end
                rnFr = rn;
                cnt = cnt + 1;
            end
        end
        %------------------------------------------------------------------
        %R               = makehgtform('xrotate',X{f,1}(1),'yrotate',X{f,1}(2),'zrotate',X{f,1}(3));
        R                = makehgtform('xrotate',deg2rad(X{f,1}(1)),'yrotate',deg2rad(X{f,1}(2)),'zrotate',deg2rad(X{f,1}(3)));
        R                = R(1:3,1:3);
        T                = [X{f,1}(4); X{f,1}(5); X{f,1}(6)];
        R                = [R T];
        camMtx{f,1}      = R;
        %------------------------------------------------------------------% getting 2D data
        j3d              = R*est3d; 
        est2d            = project_points2Short(j3d,cm.omc_ext,cm.Tc_ext,cm.fc,cm.cc,cm.kc,cm.alpha_c);
        
        tm2d             = reshape(est2d,2*nJoints,[]);
        est2dRt(:,f)     = tm2d(:);
        %------------------------------------------------------------------% getting 3D data
        j3d([2 3],:)     = flipud(j3d([2 3],:));    % '123' ---> '132' here back fliping is done in opposite direction
        j3d([1 3],:)     = flipud(j3d([1 3],:));    % '321' ---> '123'
        tm3d             = reshape(j3d,3*nJoints,[]);
        est3dRt(:,f)     = tm3d(:);
        %------------------------------------------------------------------% startValue with window size 5
        sf = max(1,f-windowsize);
        [~,ind] = min(rn(sf:f));
        ind = ind + sf - 1;
        startValue   = X{ind,1};
        
        fprintf('\b\b\b\b');
        %%
        if(testIm)
      %%%      H_writeImageTest2(opts,inp2d,est2dRt,vFile,f,bodyType)
        end
        %%
        est3d            = [];
        est3dv           = [];
    end
end
toc
orName   = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_rn.mat'];
save(fullfile(opts.saveResPath,orName),'rn','-v7.3');

rtName   = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_rtMtx.mat'];
save(fullfile(opts.saveResPath,rtName),'X','-v7.3');

camName  = [opts.subject '_' opts.actName  '_' num2str(opts.knn) '_' opts.bodyType '_camMtxComb.mat'];
save(fullfile(opts.saveResPath,camName),'camMtx','-v7.3');
end

function f = objfunLocal(x,in2d,est3d,cm)
%R     = makehgtform('xrotate',x(1),'yrotate',x(2),'zrotate',x(3));
R      = makehgtform('xrotate',deg2rad(x(1)),'yrotate',deg2rad(x(2)),'zrotate',deg2rad(x(3)));
R      = R(1:3,1:3);
T      = [x(4); x(5); x(6)];
R      = [R T];
j3d    = R*est3d;
%%est2d  = project_points2(j3d,cm.omc_ext,cm.Tc_ext,cm.fc,cm.cc,zeros(5,1),0);
%%est2d  = project_points2Short(j3d,cm.omc_ext,cm.Tc_ext,cm.fc,cm.cc,cm.kc,cm.alpha_c);
est2d  = project_points2ShortOptim(j3d,cm.omc_ext,cm.Tc_ext,cm.fc,cm.cc); % 
f      = sqrt(sum((est2d - in2d).^2));
% f = repmat(sum(sqrt(sqrt(sum((est2d - in2d).^2)))),size(x));
end

function est3d = H_regularize(knn3d,f)
%%
est3d           = knn3d(:,:,f);
est3d           = squeeze(est3d);
est3d           = reshape(est3d,3,[]);
est3d ([1 3],:) = flipud(est3d([1 3],:));    % '321' ---> '123'
est3d ([2 3],:) = flipud(est3d([2 3],:));    % '123' ---> '132'
est3d(4,:)      = 1;
end




