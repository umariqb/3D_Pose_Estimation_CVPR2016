function idx = grpname2grpidx(vsm,names)

% GRPNAME2GRPIDX locates groupings in VSMATRIX by their name.
% --------------------------------
% idx = grpname2grpidx(vsm, names)
% --------------------------------
% Description: locates groupings in VSMATRIX by their name.
% Input:       {vss} vsmatrix instance.
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
list_grps = lower(vsm.groupings(:).name);
for ii = 1:no_grps
    ind = strmatch(lower(deblank(names(ii,:))),list_grps,'exact');
    if isempty(ind)
        error('grouping named ''%s'' was not found in vsmatrix %s',...
            deblank(names(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['grouping named ''%s'' appears more than once in ' ...
            'dataset %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end