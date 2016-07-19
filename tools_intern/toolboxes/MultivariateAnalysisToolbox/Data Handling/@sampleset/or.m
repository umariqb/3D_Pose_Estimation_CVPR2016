function ss = or(ss,list)

% OR makes a union of the old sampleset with a new list.
% --------------
% ss = ss | list
% --------------
% Description: makes a union of the old sampleset with a new list.
% Input:       {ss} SAMPLESET instance.
%              {list} cell array of names.
% Output:      {ss} updated SAMPLESET.

% © Liran Carmel
% Classification: Operators
% Last revision date: 11-Aug-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(ss,{},'scalar',{mfilename,inputname(1),1}));

% unify lists
list = union(ss.sample_names,list);
ss = set(ss,'sample_names',list);