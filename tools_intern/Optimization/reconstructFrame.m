function res=reconstructFrame(Tensor,skel,mot,frame,k,currMotion,varargin)

left    = max(frame-k,1);
right   = min(frame+k,mot.nframes);

mot     = cutMotion(mot,left,right);
Tensor  = cut6DTensor(Tensor,left,right);

set              = defaultSet;
set.trajectories = 'pos';
set.currMotion   = currMotion;

if nargin==7
    set.startValue   = varargin{1};
    
%     set.lowerBounds  = cell2mat(set.startValue) - 0.3;
%     set.upperBounds  = cell2mat(set.startValue) + 0.3;
    
end

res = reconstructMotion(Tensor,skel,mot,'set',set);

% TensorForRec.data                   = TensorForRec.data(:,frame,:,:,:,:);
% TensorForRec.rootdata               = TensorForRec.rootdata(:,frame,:,:,:);
% TensorForRec.factors{2}             = TensorForRec.factors{2}(frame,:);
% TensorForRec.rootfactors{2}         = TensorForRec.rootfactors{2}(frame,:);
% TensorForRec.dimTechnicalModes(2)   = 1;
% [skel_tmp,frame]                    = constructMotion(TensorForRec,coeffs,skel);