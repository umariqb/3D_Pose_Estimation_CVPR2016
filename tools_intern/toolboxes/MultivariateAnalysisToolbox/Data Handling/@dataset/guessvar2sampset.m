function var2sampset = guessvar2sampset(ds,which_var)

% GUESSVAR2SAMPSET mapping of variables to their sampleset.
% ---------------------------------------------
% var2sampset = guessvar2sampset(ds, which_var)
% ---------------------------------------------
% Description: mapping of variables to their sampleset.
% Input:       {ds} dataset instance.
%              <{which_var}> specify which variable we should refer to when
%                   querying about number of samples. It can be a vector of
%                   variable indices, a cell array of variable names. [] or
%                   absence stands for taking all variables.
% Output:      {var2sampset} variable to sampleset mapping.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 30-Aug-2004

% parse input
error(nargchk(1,2,nargin));
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    which_var = [];
end
if isempty(which_var)
    which_var = 1:novariables(ds);
end
if ~isa(which_var,'double')
    which_var = varname2varidx(ds,which_var);
end

% get information on the samplesets
set_size = nosamples(ds.samplesets);

% loop on variables
var2sampset = nan(1,length(which_var));
no_samples = nosamples(ds.variables);
no_samples = no_samples(which_var);
for ii = 1:length(which_var)
    idx = find(set_size == no_samples(ii));
    if ~isempty(idx)
        var2sampset(ii) = idx(1);
    end
end