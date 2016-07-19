function tr = updatesubtree(tr,subtr,node)

% UPDATESUBTREE substitutes the fields of a subtree in the father tree.
% -----------------------------------
% tr = updatesubtree(tr, subtr, node)
% -----------------------------------
% Description: Let {subtr} be a subtree of {tr}. Suppose we have done
%              computation on {subtr}, changing some customized fields.
%              This function updates the resulting modified fields in the
%              father tree.
% Input:       {tr} full tree (class tree).
%              {subtr} subtree (of class tree).
%              {node} the node in {tr} that is the root of {subtr}. 
% Output:      {tr} updated full tree.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 22-Dec-2004

% parse input - other CHKVARs are done in DESCENDANTS
error(nargchk(3,3,nargin));
error(chkvar(subtr,{},'scalar',{mfilename,inputname(1),1}));

% find descendants of {node}
list = descendants(tr,node);

% update node_mass
node_mass = get(tr,'node_mass');
node_mass(list) = get(subtr,'node_mass');
tr = set(tr,'node_mass',node_mass);

% update customized fields. If a customized field appears in {subtr} but
% not in {tr}, it is ignored
cfield_names = get(subtr,'node_cfield_name');
no_cfields = get(subtr,'no_node_cfields');
% loop on all customized fields of {subtr}
for ii = 1:no_cfields
    % only if it exist in {tr} do something
    if cfieldexist(tr,cfield_names{ii})
        field = getcfield(tr,cfield_names{ii});
        field(list) = getcfield(subtr,cfield_names{ii});
        tr = setcfield(tr,cfield_names{ii},field);
    end
end