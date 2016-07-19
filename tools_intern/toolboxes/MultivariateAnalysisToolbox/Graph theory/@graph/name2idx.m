function idx = name2idx(gr,names)

% NAME2IDX finds the index of node(s) by their names.
% -------------------------
% idx = name2idx(gr, names)
% -------------------------
% Description: finds the index of node(s) by their names.
% Input:       {gr} GRAPH instance(s).
%              {names} list of node names.
% Output:      {idx} list of node indeices. If node name was not found, NaN
%                   is returned.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 30-Nov-2006

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));
names = cellstr(names);

% initialize
idx = nan(1,length(names));

% get full list of node names
node_names = nodenames(gr);

% find indices
for ii = 1:length(names)
    pos = strmatch(names{ii},node_names,'exact');
    idx(ii) = pos;
end