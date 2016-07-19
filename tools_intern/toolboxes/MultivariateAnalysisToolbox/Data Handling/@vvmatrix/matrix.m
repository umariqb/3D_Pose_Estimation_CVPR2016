function mat = matrix(vvm)

% MATRIX retrieves the variable-by-variable matrix.
% -----------------
% mat = matrix(vvm)
% -----------------
% Description: retrieves the variable-by-variable matrix.
% Input:       {vvm} VVMATRIX instance(s).
% Output:      {mat} variable-by-variable matrix for each of the instances
%                   in {vvm}. If {vvm} is not scalar, the matrices are
%                   grouped in a cell array with the same dimensions as
%                   {vvm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 08-Nov-2006

% initialize
mat = cell(size(vvm));

% loop on all instances
for ii = 1:numel(vvm)
    mat{ii} = vvm.matrix;
end

% if only one instance of {vvm}
if numel(vvm) == 1
    mat = mat{1};
end