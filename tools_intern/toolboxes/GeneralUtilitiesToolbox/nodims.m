function no_dims = nodims(x)

% NODIMS finds the ``true" number of dimensions of an array.
% -------------------
% no_dims = nodims(x)
% -------------------
% Description: Matlab function NDIMS returns 2 for both matrices, vectors,
%              scalars and voids. NODIMS corrects it in returning 2,1,0,0
%              respectively. Also, NODIMS ignores ``degenerate" dimensions
%              (just like NDIMS does), and therefore
%              nodims(ones(3,4,5,1,6)) is only 4 and not 5.
% Input:       {x} any variable.
% Output:      {no_dims} number of dimensions of {x}.

% © Liran Carmel
% Classification: Variable verification
% Last revision date: 10-Feb-2004

no_dims = sum(size(x)>1);