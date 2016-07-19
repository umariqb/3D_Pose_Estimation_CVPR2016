function mot = H_rigidTransform(mot,motGT,varargin)

if(nargin > 3)
    tdata = varargin{2};
end
if(nargin > 2)
    rdata = varargin{1};
end

% A = nan(mot.njoints,3);
% B = nan(mot.njoints,3);
% A = nan(mot1.njoints,2);
% B = nan(mot2.njoints,2);

for k = 1:mot.nframes
    t=1;
    for i = 1:mot.njoints
        A(t:t+2,k) = mot.jointTrajectories{i}(:,k)';  % N X 3
        B(t:t+2,k) = motGT.jointTrajectories{i}(:,k)';  % N X 3
        t = t+3;
    end
    Aa = reshape(A(:,k),3,mot.njoints)';
    Bb = reshape(B(:,k),3,mot.njoints)';
    [ret_R{k}, ret_t{k}] = H_getRigidTransform(Aa, Bb);
end
% back to original position by retrieved orintation and translation
if(nargin > 2)
    %------------------------------------------------------------------
    for f = 1:mot.nframes
        vmtx = viewmtx(rdata(1,f),rdata(2,f));
        xRotMtx  = [1 0 0 0;0 0 -1 0;0 1 0 0; 0 0 0 1];
        vmtx     = vmtx * xRotMtx;
        R{f} = matrix2quat(vmtx(1:3,1:3));
    end
end
%%
if(exist('R','var') && ~exist('tdata','var'))
    for f = 1:mot.nframes
        for j = 1:mot.njoints
            mot.jointTrajectories{j}(:,f) = quatrot(mot.jointTrajectories{j}(:,f),R{f}) +  ret_t{f};  % N X 3
        end
    end
elseif(exist('R','var') && exist('tdata','var'))
    for f = 1:mot.nframes
        for j = 1:mot.njoints
            mot.jointTrajectories{j}(:,f) = quatrot(mot.jointTrajectories{j}(:,f),R{f}) +  tdata;  % N X 3
        end
    end
else
    for f = 1:mot.nframes
        for j = 1:mot.njoints
            mot.jointTrajectories{j}(:,f) = ret_R{f} * mot.jointTrajectories{j}(:,f) +  ret_t{f};  % N X 3
        end
    end
end
end

