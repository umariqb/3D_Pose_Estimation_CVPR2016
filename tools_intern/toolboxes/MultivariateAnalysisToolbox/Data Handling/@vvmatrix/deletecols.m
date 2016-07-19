function vvm = deletecols(vvm,to_remove)

% DELETECOLS eliminate col-variables from a VVMATRIX instance.
% --------------------------------
% vvm = deletecols(vvm, to_remove)
% --------------------------------
% Description: eliminate col-variables from a VVMATRIX instance.
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
    to_remove = colname2colidx(vvm,to_remove);
end
no_vars = nocols(vvm);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_vars}},...
    {mfilename,inputname(2),2}));

% delete col-variables from {vvm}
vvm.matrix(:,to_remove) = [];
vvm.datamatrix = setnocols(vvm.datamatrix,no_vars - length(to_remove));
if vvm.isroweqcol
    % now the rows and cols are no longer the same
    vvm.isroweqcol = false;
    vvm.row_sampleset = vvm.sampleset;
    vvm.col_sampleset = vvm.sampleset;
    vvm.col_sampleset = deletesamples(vvm.col_sampleset,to_remove);
    vvm.sampleset = [];
else
    % rows and cols were not the same in the first place
    vvm.col_sampleset = deletesamples(vvm.col_sampleset,to_remove);
end