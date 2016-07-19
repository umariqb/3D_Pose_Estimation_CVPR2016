function Tensor=HOSVD(Tensor,varargin)

switch nargin
    case 1
        tuckerDim=size(Tensor.data);
    case 2
        tuckerDim=varargin{1};
    otherwise
        error('Wrong number of Args');
end

[Tensor.factors,Tensor.core] = tucker(Tensor.data, tuckerDim);
[Tensor.rootfactors,Tensor.rootcore]= tucker(Tensor.rootdata, size(Tensor.rootdata));
