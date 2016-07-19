function grp2sampset = guessgrp2sampset(ds,which_grp)

% GUESSGRP2SAMPSET mapping of groupings to their sampleset.
% ---------------------------------------------
% grp2sampset = guessgrp2sampset(ds, which_grp)
% ---------------------------------------------
% Description: mapping of groupings to their sampleset.
% Input:       {ds} dataset instance.
%              <{which_grp}> specify which grouping we should refer to when
%                   querying about number of samples. It can be a vector of
%                   grouping indices, a cell array of grouping names. [] or
%                   absence stands for taking all groupings.
% Output:      {grp2sampset} grouping to sampleset mapping.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 30-Aug-2004

% parse input
error(nargchk(1,2,nargin));
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    which_grp = [];
end
if isempty(which_grp)
    which_grp = 1:ds.no_groupings;
end
if ~isa(which_grp,'double')
    which_grp = grpname2grpidx(ds,which_grp);
end

% get information on the samplesets
set_size = nosamples(ds.samplesets);

% loop on variables
grp2sampset = nan(1,length(which_grp));
no_samples = nosamples(ds.groupings);
no_samples = no_samples(which_grp);
for ii = 1:length(which_grp)
    idx = find(set_size == no_samples(ii));
    if ~isempty(idx)
        grp2sampset(ii) = idx(1);
    end
end