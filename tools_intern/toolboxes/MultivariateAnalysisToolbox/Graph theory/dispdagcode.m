function dispdagcode(code)

% DISPDAGCODE displays a DAG code to the screen.
% -----------------
% dispdagcode(code)
% -----------------
% Description: displays a DAG code to the screen.
% Input:       {code} a DAG-code. For a digraph with {n} nodes, a DAG-code
%                   is an (n-1)-tuple of sets of nodes.

% © Liran Carmel
% Classification: Computations
% Last revision date: 20-Mar-2008

% initialize
n = length(code);
str = 'DAG code: {';

% if code is empty
if n == 0
    str = sprintf('%s}',str);
    disp(str);
    return;
end

% start displaying all sets in code
str = sprintf('%s[%s]',str,set2str(code{1}));
for ii = 2:n
    str = sprintf('%s,[%s]',str,set2str(code{ii}));
end
str = sprintf('%s}',str);
disp(str);

function str = set2str(S)

% initialize
n = length(S);

% skip if set is empty
if isempty(S)
    str = '';
    return;
end

% first term
str = sprintf('%d',S(1));

% next terms
for ii = 2:n
    str = sprintf('%s,%d',str,S(ii));
end