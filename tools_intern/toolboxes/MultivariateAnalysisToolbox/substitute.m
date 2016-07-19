function list = substitute(list,origin,substit)

% SUBSTITUTE substitutes values in a list with a different set of values.
% ----------------------------------------
% list = substitute(list, origin, substit)
% ----------------------------------------
% Description: substitutes any set of values in a list with a different set
%              of values.
% Input:       {list} numerical vector or a string.
%              {origin} cell array of items to replace.
%              {substit} cell array of items that are substituted instead
%                   of the items in {origin}.
% Output:      {list} updated {list}.
% Comment:     low-level function -> no input verification.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 14-Mar-2006

% discriminate between a string and numerical vector
if isa(list,'char') % string
    list = regexprep(list,origin,substit);
else                % numerical vector
    % initialize
    orig_list = list;
    % replace each item in its turn
    for ii = 1:length(origin)
        list(orig_list==origin(ii)) = substit(ii);
    end
end