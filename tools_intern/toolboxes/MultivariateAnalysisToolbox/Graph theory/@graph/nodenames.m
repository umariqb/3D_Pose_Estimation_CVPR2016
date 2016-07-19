function names = nodenames(gr,nodes)

% NODENAMES retrieves the name of the nodes in the graph.
% ----------------------------
% names = nodenames(gr, nodes)
% ----------------------------
% Description: retrieves the name of the nodes in the graph.
% Input:       {gr} GRAPH instance(s).
%              <{idx}> indices of desired nodes. If absent, all nodes are
%                   taken.
% Output:      {names} list of names (as a cell array) in each of the
%                   instances in {gr}. If {gr} is not scalar, the lists are
%                   grouped in another cell array with the same dimensions
%                   as {gr}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 19-Jan-2005

% parse input
if nargin == 1
    nodes = 1:nonodes(gr);
else
    error(chkvar(nodes,'integer',{'vector',{'greaterthan',0}},...
        {mfilename,inputname(2),2}));
end

% initialize
names = cell(size(gr));

% loop on all instances
for ii = 1:numel(gr)
    names{ii} = gr(ii).node_name(nodes);
end

% if a single instance
if isscalar(gr)
    names = names{1};
end