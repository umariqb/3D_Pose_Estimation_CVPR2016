function idx = ssname2ssidx(ds,name)

% SSNAME2SSIDX locates samplesets in dataset by their name.
% ---------------------------
% idx = ssname2ssidx(ds,name)
% ---------------------------
% Description: locates samplesets in dataset by their name.
% Input:       {ds} dataset instance(s).
%              {name} cell array of names, or character matrix of names.
% Output:      {idx} index(ices) of corresponding dataset(s).

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 14-Jun-2006

% no input parsing - private directory

% turn cell into characters, if required
name = lower(char(name));

% initialize
no_ss = size(name,1);
idx = zeros(1,no_ss);

% loop on variables names
list_ss = lower(ds.samplesets(:).name);
for ii = 1:no_ss
    ind = strmatch(lower(deblank(name(ii,:))),list_ss,'exact');
    if isempty(ind)
        error('sampleset named ''%s'' was not found in dataset %s',...
            deblank(name(ii,:)),upper(inputname(1)));
    elseif length(ind) > 1
        error(['sampleset named ''%s'' appears more than once in ' ...
            'dataset %s'],deblank(names(ii,:)),upper(inputname(1)));
    else
        idx(ii) = ind;
    end
end