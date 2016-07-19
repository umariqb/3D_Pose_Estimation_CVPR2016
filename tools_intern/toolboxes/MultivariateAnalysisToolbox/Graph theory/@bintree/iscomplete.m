function [indeed, how, which] = iscomplete(tr)

% ISCOMPLETE tests whether the binary tree is fully connected.
% -----------------------------------
% [indeed how which] = iscomplete(tr)
% -----------------------------------
% Description: tests whether the binary tree is fully connected.
% Input:       {tr} BINTREE instance.
% Output:      {indeed} is true for complete binary trees, and false
%                   otherwise.
%              {how} designates parent-less node by 'parent', or node with
%                   a single descendants by 'descendant'.
%              {which} the index(ices) of the problematic node.

% © Liran Carmel
% Classification: Queries
% Last revision date: 09-Mar-2006

% defaults
indeed = true;
how = '';

% test that every node has a parent
rts = find(get(tr,'parent')==0);
if length(rts) > 1
    indeed = false;
    how = 'parent';
    which = rts;
    return;
end

% test that every node has zero or two descendants
nonleaves = allbut(leaves(tr),nonodes(tr));
which = find(tr.l_node(nonleaves) .* tr.r_node(nonleaves) == 0);
if ~isempty(which)
    indeed = false;
    how = 'descendant';
end