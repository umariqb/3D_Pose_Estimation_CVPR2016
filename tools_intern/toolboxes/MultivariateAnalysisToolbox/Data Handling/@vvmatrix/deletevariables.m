function vvm = deletevariables(vvm,to_remove)

% DELETEVARIABLES eliminate variables from a VVMATRIX instance.
% -------------------------------------
% vvm = deletevariables(vvm, to_remove)
% -------------------------------------
% Description: eliminate both column and row variables from a VVMATRIX
%              instance. This function does not work when the row and
%              column samplesets are not the same.
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
if ~vvm.isroweqcol
    error('%s: illegal when row and column variables are not the same',...
        upper(mfilename));
end
if ~isa(to_remove,'double')
    to_remove = colname2colidx(vvm,to_remove);
end
no_vars = nocols(vvm);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_vars}},...
    {mfilename,inputname(2),2}));

% delete variables from {vvm}
vvm.matrix(:,to_remove) = [];
vvm.matrix(to_remove,:) = [];
vvm.datamatrix = setnocols(vvm.datamatrix,no_vars - length(to_remove));
vvm.datamatrix = setnorows(vvm.datamatrix,no_vars - length(to_remove));
vvm.sampleset = deletesamples(vvm.sampleset,to_remove);