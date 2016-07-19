function names = variablenames(lt, vars)

% VARIABLENAMES retrieves the names of the original variables in LINTRANS.
% -------------------------------
% names = variablenames(lt, vars)
% -------------------------------
% Description: retrieves the names of the original variables in LINTRANS.
% Input:       {lt} LINTRANS instance(s).
%              <{vars}> specify a subset of the variables. By default, all
%                   variables are selected.
% Output:      {names} cell array of cell arrays, with the names of the
%                   original variables in each of the instances in {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Jun-2005

% parse input line
if nargin == 1
    vars = [];
else
    error(chkvar(vars,'integer','vector',{mfilename,inputname(2),2}));
end

% initialize
names = cell(size(lt));

% substitute names
if isempty(vars)
    for ii = 1:numel(lt)
        names{ii} = samplenames(lt(ii).variableset);
    end
else
    for ii = 1:numel(lt)
        names{ii} = lt(ii).variableset(vars);
    end
end

% if {lt} is scalar, make it a single cell array
if isscalar(lt)
    names = names{1};
end