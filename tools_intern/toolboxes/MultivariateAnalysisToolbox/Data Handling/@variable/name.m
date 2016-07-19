function nm = name(vr)

% NAME retrieves the name of variable(s).
% -------------
% nm = name(vr)
% -------------
% Description: retrieves the name of variable(s).
% Input:       {vr} variable instance(s).
% Output:      {nm} name of each of the instances in {vr}. If {vr} is of
%                   length {n}, than {nm} will be a cell array of length
%                   {n}. If {vr} is a scalar, {nm} would be a char vector
%                   (instead of a cell array).

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 08-Oct-2004

% initialize
nm = cell(size(vr));

% loop on all instances
for ii = 1:numel(vr)
    nm{ii} = vr(ii).name;
end

% make the cell a char if it is a scalar
if numel(nm) == 1
    nm = char(nm);
end