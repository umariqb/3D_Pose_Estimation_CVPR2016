function idx = rowname2rowidx(vvm,names)

% ROWNAME2ROWIDX locates row-variables in VVMATRIX by their name.
% --------------------------------
% idx = rowname2rowidx(vvm, names)
% --------------------------------
% Description: locates row-variables in VVMATRIX by their name.
% Input:       {dm} VVMATRIX instance.
%              {names} cell array of names, or character matrix of names.
% Output:      {idx} index(ices) of corresponding row-variable(s).

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 06-Oct-2006

% turn cell into characters, if required
names = char(names);

% initialize
no_vars = size(names,1);
idx = zeros(1,no_vars);

% loop on variables names
ss = lower(samplenames(get(vvm,'row_sampleset')));
for ii = 1:no_vars
    ind = strmatch(lower(deblank(names(ii,:))),ss,'exact');
    if isempty(ind)
        error('variable named ''%s'' was not found in vvmatrix %s',...
            deblank(names(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['variable named ''%s'' appears more than once in ' ...
            'vvmatrix %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end