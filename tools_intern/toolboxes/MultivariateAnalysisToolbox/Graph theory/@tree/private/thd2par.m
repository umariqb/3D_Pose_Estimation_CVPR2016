function p = thd2par(D)

% THD2PAR computes, given THD, the parent vector.
% --------------
% W = thd2par(D)
% --------------
% Description: computes, given THD, the parent vector.
% Input:       {D} target height differences matrix.
% Output:      {p} parent vector.

% © Liran Carmel
% Classification: Computations
% Last revision date: 03-Sep-2004

% initialize
no_nodes = size(D,1);
p = zeros(1,no_nodes);

% find negative contributions
for ii = 1:no_nodes
    idx = find(D(ii,:) < 0);
    if isempty(idx)
        p(ii) = 0;
    else
        p(ii) = idx;
    end
end