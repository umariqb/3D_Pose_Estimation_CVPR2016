function vars = variables(ds)

% VARIABLES variables of dataset(s).
% --------------------
% vars = variables(ds)
% --------------------
% Description: returns the variables of dataset(s).
% Input:       {ds} dataset instance(s).
% Output:      {vars} if {ds} contains one instance, {vars} is just the
%                   field 'variables'. Otherwise, it is a cell array, with
%                   each cell containing the 'variables' field of one
%                   dataset instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 29-Nov-2004

% parse input
error(nargchk(1,1,nargin));

% substitute values
vars = cell(size(ds));
for ii = 1:numel(ds)
    vars{ii} = ds(ii).variables;
end

% don't make a cell array for a single {ds} instance
if numel(ds) == 1
    vars = vars{1};
end