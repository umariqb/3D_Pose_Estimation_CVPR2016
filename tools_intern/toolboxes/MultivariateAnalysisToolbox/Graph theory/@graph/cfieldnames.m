function names = cfieldnames(gr)

% CFIELDNAMES lists the customized fields in a GRAPH object.
% -----------------------
% names = cfieldnames(gr)
% -----------------------
% Description: lists the customized fields in a GRAPH object.
% Input:       {gr} GRAPH instance.
% Output:      {names} list of customized fields (cell array).

% © Liran Carmel
% Classification: Customized fields manipulations
% Last revision date: 04-Aug-2005

% check that {gr} is scalar
error(chkvar(gr,{},'scalar',{mfilename,inputname(1),1}));

% get the list
names = gr.node_cfield_name;