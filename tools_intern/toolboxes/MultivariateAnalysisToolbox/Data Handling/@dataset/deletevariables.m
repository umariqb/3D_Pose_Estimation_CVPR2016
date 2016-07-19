function ds = deletevariables(ds,to_remove)

% DELETEVARIABLES eliminate variables from a DATASET instance.
% -----------------------------------
% ds = deletevariables(ds, to_remove)
% -----------------------------------
% Description: eliminate variables from a DATASET instance.
% Input:       {ds} DATASET instance.
%              {to_remove} variables to delete. Can be either their
%                   indices, or their names (char-matrix or cell-vector).
% Output:      {ds} updated dataset instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 28-Nov-2006

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));
if ~isa(to_remove,'double')
    to_remove = varname2varidx(ds,to_remove);
end
no_vars = novariables(ds);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_vars}},...
    {mfilename,inputname(2),2}));

% delete variables from {ds}
no_vars = ds.no_variables;
for ii = 1:length(to_remove)
    switch ds.variables(ii).level
        case 'nominal'
            no_vars = no_vars - [1 0 0 0 1];
        case 'ordinal'
            no_vars = no_vars - [0 1 0 0 1];
        case 'numerical'
            no_vars = no_vars - [0 0 1 0 1];
        case 'unknown'
            no_vars = no_vars - [0 0 0 1 1];
    end
end
ds.no_variables = no_vars;
ds.variables(to_remove) = [];
ds.var2sampset(to_remove) = [];