function name = idx2name(gr,idx)

% IDX2NAME finds the name of node(s) by their index.
% ------------------------
% name = idx2name(gr, idx)
% ------------------------
% Description: finds the name of node(s) by their index.
% Input:       {gr} GRAPH instance(s).
%              {idx} list of indices.
% Output:      {name} cell array of names matching the indices.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 17-Jan-20068

% get names
name = get(gr,'node_name');
name = name(idx);