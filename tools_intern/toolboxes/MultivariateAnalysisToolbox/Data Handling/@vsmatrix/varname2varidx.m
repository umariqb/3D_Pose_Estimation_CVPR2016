function idx = varname2varidx(vsm,names)

% VARNAME2VARIDX locates variables in vsmatrix by their name.
% --------------------------------
% idx = varname2varidx(vsm, names)
% --------------------------------
% Description: locates variables in dataset by their name.
% Input:       {vsm} vsmatrix instance.
%              {names} cell array of names, or character matrix of names.
% Output:      {idx} index(ices) of corresponding variable(s).

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 04-Feb-2005

% no input parsing - private directory

% turn cell into characters, if required
names = char(names);

% initialize
no_vars = size(names,1);
idx = zeros(1,no_vars);

% loop on variables names
list_vars = lower(vsm.variables(:).name);
for ii = 1:no_vars
    ind = strmatch(lower(deblank(names(ii,:))),list_vars,'exact');
    if isempty(ind)
        error('variable named ''%s'' was not found in vsmatrix %s',...
            deblank(names(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['variable named ''%s'' appears more than once in ' ...
            'dataset %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end