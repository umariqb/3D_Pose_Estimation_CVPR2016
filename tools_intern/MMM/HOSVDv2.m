function Tensor=HOSVDv2(Tensor,varargin)

Tensor.data     = squeeze(Tensor.data);
Tensor.rootdata = squeeze(Tensor.rootdata);

dimTechnicalModes = Tensor.dimTechnicalModes(Tensor.dimTechnicalModes~=1);
dimNaturalModes = Tensor.dimNaturalModes(Tensor.dimNaturalModes~=1);

switch nargin
    case 1
        tuckerDim=[dimTechnicalModes dimNaturalModes];
    case 2
        tuckerDim=varargin{1};
    otherwise
        error('Wrong number of Args');
end

[Tensor.factors,Tensor.core] = tucker(Tensor.data, tuckerDim);
[Tensor.rootfactors,Tensor.rootcore]= tucker(Tensor.rootdata, size(Tensor.rootdata));
