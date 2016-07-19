function idx = varname2varidx(ds,names)

% VARNAME2VARIDX locates variables in dataset by their name.
% -------------------------------
% idx = varname2varidx(ds, names)
% -------------------------------
% Description: locates variables in dataset by their name.
% Input:       {ds} dataset instance.
%              {names} cell array of names, or character matrix of names.
% Output:      {idx} index(ices) of corresponding variable(s).

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 10-Jan-2005

% no input parsing - private directory

% turn cell into characters, if required
names = char(names);

% initialize
no_vars = size(names,1);
idx = zeros(1,no_vars);

% loop on variables names
list_vars = lower(ds.variables(:).name);
for ii = 1:no_vars
    ind = strmatch(lower(deblank(names(ii,:))),list_vars,'exact');
    if isempty(ind)
        error('variable named "%s" was not found in dataset %s',...
            deblank(names(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['variable named ''%s'' appears more than once in ' ...
            'dataset %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end