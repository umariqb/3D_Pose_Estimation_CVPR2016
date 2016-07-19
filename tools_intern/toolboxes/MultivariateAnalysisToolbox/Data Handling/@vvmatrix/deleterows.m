function vvm = deleterows(vvm,to_remove)

% DELETEROWS eliminate row-variables from a VVMATRIX instance.
% --------------------------------
% vvm = deleterows(vvm, to_remove)
% --------------------------------
% Description: eliminate row-variables from a VVMATRIX instance.
% Input:       {vvm} vvmatrix instance.
%              {to_remove} variables to delete. Can be either their
%                   indices, or their names (char-matrix or cell-vector).
% Output:      {vvm} updated VVMATRIX instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 08-Nov-2006

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vvm,{},'scalar',{mfilename,inputname(1),1}));
if ~isa(to_remove,'double')
    to_remove = rowname2rowidx(vvm,to_remove);
end
no_vars = norows(vvm);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_vars}},...
    {mfilename,inputname(2),2}));

% delete row-variables from {vvm}
vvm.matrix(to_remove,:) = [];
vvm.datamatrix = setnorows(vvm.datamatrix,no_vars - length(to_remove));
if vvm.isroweqcol
    % now the rows and cols are no longer the same
    vvm.isroweqcol = false;
    vvm.col_sampleset = vvm.sampleset;
    vvm.row_sampleset = vvm.sampleset;
    vvm.row_sampleset = deletesamples(vvm.row_sampleset,to_remove);
    vvm.sampleset = [];
else
    % rows and cols were not the same in the first place
    vvm.row_sampleset = deletesamples(vvm.row_sampleset,to_remove);
end