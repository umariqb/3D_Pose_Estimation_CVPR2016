function vsm = deletesamples(vsm,to_remove)

% DELETESAMPLES eliminate samples from a vsmatrix instance.
% -----------------------------------
% vsm = deletesamples(vsm, to_remove)
% -----------------------------------
% Description: eliminate samples from a vsmatrix instance.
% Input:       {dm} vsmatrix instance.
%              {to_remove} samples to delete.
% Output:      {dm} updated vsmatrix instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 17-Jan-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
no_samples = nosamples(vsm);
error(chkvar(to_remove,'integer',{'vector',{'eqlower',no_samples}},...
    {mfilename,inputname(2),2}));

% delete samples from {variables}
vsm.variables = deletesamples(vsm.variables,to_remove);
% delete samples from {groupings}
if ~isempty(vsm.groupings)
    vsm.groupings = deletesamples(vsm.groupings,to_remove);
end
% delete samples from {samples}
vsm.sampleset = deletesamples(vsm.sampleset,to_remove);
% modify {no_cols}
no_cols = get(vsm.datamatrix,'no_cols');
vsm.datamatrix = setnocols(vsm.datamatrix,no_cols - length(to_remove));