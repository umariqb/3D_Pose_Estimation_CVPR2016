function names = factornames(lt, facts)

% FACTORNAMES retrieves the names of the factors in LINTRANS.
% ------------------------------
% names = factornames(lt, facts)
% ------------------------------
% Description: retrieves the names of the factors in LINTRANS.
% Input:       {lt} LINTRANS instance(s).
%              <{facts}> specify a subset of the factors. By default, all
%                   factors are selected.
% Output:      {names} cell array of cell arrays, with the names of the
%                   factors in each of the instances in {lt}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 06-Dec-2006

% parse input line
if nargin == 1
    facts = [];
else
    error(chkvar(facts,'integer','vector',{mfilename,inputname(2),2}));
end

% initialize
names = cell(size(lt));

% substitute names
if isempty(facts)
    for ii = 1:numel(lt)
        names{ii} = samplenames(lt(ii).factorset);
    end
else
    for ii = 1:numel(lt)
        names{ii} = lt(ii).factorset(facts);
    end
end

% if {lt} is scalar, make it a single cell array
if isscalar(lt)
    names = names{1};
end