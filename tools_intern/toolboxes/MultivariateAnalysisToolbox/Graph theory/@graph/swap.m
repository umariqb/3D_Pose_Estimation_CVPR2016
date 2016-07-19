function [gr, first, last] = swap(gr,node_1,node_2)

% SWAP replaces the indices of two nodes.
% ------------------------------------------
% [gr first last] = swap(gr, node_1, node_2)
% ------------------------------------------
% Description: replaces the indices of two nodes.
% Input:       {gr} graph instance.
%              {node_1} first node.
%              {node_2} second node.
% Output:      {gr} the graph with the two nodes replaced.
%              {first} the smallest of {node_1} and {node_2}.
%              {last} the highest of {node_1} and {node_2}.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 03-Sep-2004

% parse input line
error(nargchk(3,3,nargin));

% sort nodes by their current index
first = min(node_1,node_2);
last = max(node_1,node_2);
if first == last
    return;
end

% modify node_name
node_name = gr.node_name;
gr.node_name = [node_name(1:first-1) node_name(last) ...
    node_name(first+1:last-1) node_name(first) node_name(last+1:end)];

% modify node_mass
node_mass = gr.node_mass;
gr.node_mass = [node_mass(1:first-1) node_mass(last) ...
    node_mass(first+1:last-1) node_mass(first) node_mass(last+1:end)];

% modify customized fields
for ii = 1:gr.no_node_cfields
    f_val = gr.node_cfield{ii};
    tmp = f_val{first};
    f_val{first} = f_val{last};
    f_val{last} = tmp;
    gr.node_cfield{ii} = f_val;
end

% modify weights
W = gr.weights;
tmp = W(first,:);
W(first,:) = W(last,:);
W(last,:) = tmp;
tmp = W(:,first);
W(:,first) = W(:,last);
W(:,last) = tmp;
gr.weights = W;