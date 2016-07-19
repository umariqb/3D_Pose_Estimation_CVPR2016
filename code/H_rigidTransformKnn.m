function obj = H_rigidTransformKnn(obj,motGT,varargin)

if(nargin > 3)
    tData = varargin{2};
end
if(nargin > 2)
    rData = varargin{1};
end

if(isstruct(obj))
    knnPos         = reshape(obj.data,3*length(obj.knnJoints),obj.knn,size(obj.data,2));
    g = 1;
    for j = 1:size(knnPos,2)   % KNN
        knnDataTmp(:,1,:)   = knnPos (:,j,:);
        knnData             = squeeze(knnDataTmp);
        % knnData (2:3:end,:) = -knnData (2:3:end,:);
        mot     = H_mat2cellMot(knnData,motGT);
        mot     = H_rigidTransform(mot,motGT);
        if(exist('rdata','var') && ~exist('tdata','var'))
            mot   = H_rigidTransform(mot,motGT,rData);
        end
        if(exist('rdata','var') && exist('tdata','var'))
            mot   = H_rigidTransform(mot,motGT,rData,tData);
        end
        knnData = cell2mat(mot.jointTrajectories);
        
        sz = size(knnData,1);
        obj.data(g:g+sz-1,:) = knnData(:,:);
        g = g + sz;
    end
else
    g = 1;
    
    mot     = H_mat2cellMot(obj,motGT);
    mot     = H_rigidTransform(mot,motGT);
    if(exist('rdata','var') && ~exist('tdata','var'))
        mot   = H_rigidTransform(mot,motGT,rData);
    end
    if(exist('rdata','var') && exist('tdata','var'))
        mot   = H_rigidTransform(mot,motGT,rData,tData);
    end
    knnData = cell2mat(mot.jointTrajectories);
    
    sz = size(knnData,1);
    obj(g:g+sz-1,:) = knnData(:,:);
    g = g + sz;
    
end
end


