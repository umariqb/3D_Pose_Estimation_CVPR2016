function mat = matrix(vsm)

% MATRIX retrieves the variables-by-samples matrix.
% -----------------
% mat = matrix(vsm)
% -----------------
% Description: retrieves the variables-by-samples matrix.
% Input:       {vsm} vsmatrix instance(s).
% Output:      {mat} variables-by-samples matrix for each of the instances
%                   in {vsm}. If {vsm} is not scalar, the matrices are
%                   grouped in a cell array with the same dimensions as
%                   {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 28-Sep-2004

% initialize
mat = cell(size(vsm));

% loop on all instances
for ii = 1:numel(vsm)
    if novariables(vsm(ii))
        mat{ii} = vsm.variables(:,:);
    end
end

% if only one instance of {vsm}
if numel(vsm) == 1
    mat = mat{1};
end