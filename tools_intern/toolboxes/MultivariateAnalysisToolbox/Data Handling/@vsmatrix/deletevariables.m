function vsm = deletevariables(vsm,to_remove)

% DELETEVARIABLES eliminate variables from a vsmatrix instance.
% -------------------------------------
% vsm = deletevariables(vsm, to_remove)
% -------------------------------------
% Description: eliminate variables from a vsmatrix instance.
% Input:       {vsm} vsmatrix instance.
%              {to_remove} variables to delete. Can be either their
%                   indices, or their names (char-matrix or cell-vector).
% Output:      {vsm} updated vsmatrix instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 17-Jan-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
if ~isa(to_remove,'double')
    to_remove = varname2varidx(vsm,to_remove);
end
no_vars = novariables(vsm);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_vars}},...
    {mfilename,inputname(2),2}));

% delete variables from {vsm}
vsm.variables(to_remove) = [];
vsm.datamatrix = setnorows(vsm.datamatrix,no_vars - length(to_remove));