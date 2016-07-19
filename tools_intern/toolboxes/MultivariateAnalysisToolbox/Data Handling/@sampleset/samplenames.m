function names = samplenames(ss)

% SAMPLENAMES retrieves the sample names of samplesets.
% -----------------------
% names = samplenames(ss)
% -----------------------
% Description: retrieves the sample names of samplesets.
% Input:       {ss} sampleset instance(s).
% Output:      {names} list of names (as a cell array) in each of the
%                   instances in {ss}. If {ss} is not scalar, the lists are
%                   grouped in another cell array with the same dimensions
%                   as {ss}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 19-Jan-2005

% initialize
names = cell(size(ss));

% loop on all instances
for ii = 1:numel(ss)
    names{ii} = ss(ii).sample_names;
end

% if a single instance
if isscalar(ss)
    names = names{1};
end