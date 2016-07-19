function D = par2thd(p)

% PAR2THD computes, given parent vector, the THD matrix.
% --------------
% D = par2thd(p)
% --------------
% Description: computes, given parent vector, the THD matrix.
% Input:       {p} parent vector.
% Output:      {D} target height differences matrix.

% © Liran Carmel
% Classification: Computations
% Last revision date: 03-Sep-2004

% initialize
no_nodes = length(p);
D = zeros(no_nodes);

% loop on parents
for ii = 1:no_nodes
    if p(ii)    % non-root
        D(p(ii),ii) = 1;
        D(ii,p(ii)) = -1;
    end
end