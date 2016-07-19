function idx = grpname2grpidx(ds,names)

% GRPNAME2GRPIDX locates groupings in dataset by their name.
% -------------------------------
% idx = grpname2grpidx(ds, names)
% -------------------------------
% Description: locates groupings in dataset by their name.
% Input:       {ds} dataset instance.
%              {names} cell array of names, or character matrix of names.
% Output:      {idx} index(ices) of corresponding grouping(s).

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 10-Jan-2005

% no input parsing

% turn cell into characters, if required
names = char(names);

% initialize
no_grps = size(names,1);
idx = zeros(1,no_grps);

% loop on variables names
list_grps = lower(ds.groupings(:).name);
for ii = 1:no_grps
    ind = strmatch(lower(deblank(names(ii,:))),list_grps,'exact');
    if isempty(ind)
        error('grouping named ''%s'' was not found in dataset %s',...
            deblank(names(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['grouping named ''%s'' appears more than once in ' ...
            'dataset %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end