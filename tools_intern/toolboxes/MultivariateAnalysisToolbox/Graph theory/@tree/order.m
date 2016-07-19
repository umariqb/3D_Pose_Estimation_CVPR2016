function [tr, idx] = order(tr,how)

% ORDER orders the nodes in a tree.
% -------------------------
% [tr idx] = order(tr, how)
% -------------------------
% Description: orders the nodes in a tree.
% Input:       {tr} tree instance.
%              {how} keyword to control the ordering. Currently
%                   available:
%                   'topological' - if node {i} is the parent of node {j},
%                       then i < j.
%                   'root' - puts the root as the first node (#1).
%                   'leaves' - puts the leaves as the last nodes. Formally,
%                       if {i} is a leaf, than i > j for any non-leaf node
%                       {j}.
%                   'junctiontree' - combination of 'root','leaves', and
%                       'topological'.
% Output:      {tr} ordered trees.
%              {idx} the new order of nodes.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 14-Mar-2006

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(tr,{},'scalar',{mfilename,'',1}));
error(chkvar(how,'char','vector',{mfilename,'',2}));

% initialize
idx = 1:get(tr,'no_nodes');

% decide on the type of ordering
switch str2keyword(how,4)
    case 'topo'
        % initialize
        no_nodes = get(tr,'no_nodes');
        pa = get(tr,'parents');
        has_changed = true;
        % iterate until the order is topological
        while has_changed
            has_changed = false;
            % find "reversed" pair of nodes
            node = 1;
            while node<=no_nodes
                if pa(node) > node
                    has_changed = true;
                    tr = swap(tr,node,pa(node));
                    idx = substitute(idx,[node pa(node)],[pa(node) node]);
                    pa = get(tr,'parents');
                end
                % advance to the next node
                node = node + 1;
            end
        end
    case 'root'
        r = root(tr);
        tr = swap(tr,1,r);
        idx(1) = r;
        idx(r) = 1;
    case 'leav'
        leaf = leaves(tr);
        loc = get(tr,'no_nodes');
        while ~isempty(leaf)
            tr = swap(tr,leaf(end),loc);
            idx = substitute(idx,[leaf(end) loc],[loc leaf(end)]);
            leaf(end) = [];
            loc = loc - 1;
        end
    case 'junc'
        [tr idx] = order(tr,'root');
        [tr idx1] = order(tr,'leaves');
        idx = idx(idx1);
        [tr idx1] = order(tr,'topological');
        idx = idx(idx1);
    otherwise
        error('%s: Unfamiliar ordering algorithm',upper(how));
end