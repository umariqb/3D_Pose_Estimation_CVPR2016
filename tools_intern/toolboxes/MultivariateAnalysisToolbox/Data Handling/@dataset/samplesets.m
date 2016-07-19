function ss = samplesets(ds)

% SAMPLESETS samplesets of dataset(s).
% -------------------
% ss = samplesets(ds)
% -------------------
% Description: returns the samplesets of dataset(s).
% Input:       {ds} dataset instance(s).
% Output:      {ss} if {ds} contains one instance, {ss} is just the field
%                   'samplesets'. Otherwise, it is a cell array, with each
%                   cell containing the 'samplesets' field of one dataset
%                   instance.


% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 29-Nov-2004

% parse input
error(nargchk(1,1,nargin));

% substitute values
ss = cell(size(ds));
for ii = 1:numel(ds)
    ss{ii} = ds(ii).samplesets;
end

% don't make a cell array for a single {ds} instance
if numel(ds) == 1
    ss = ss{1};
end