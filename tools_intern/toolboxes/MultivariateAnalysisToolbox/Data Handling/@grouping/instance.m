function gr = instance(gr,idx)

% INSTANCE extracts a specific instance from a grouping array.
% ----------------------
% gr = instance(gr, idx)
% ----------------------
% Description: extracts a specific instance from a grouping array. It is
%              required to avoid ambiguity such as gr(2). In this case, if
%              {gr} is a vector, the returned value is a grouping instance,
%              while if {gr} is a scalar, the returned value is the second
%              assignment value of the first hierarchy.
% Input:       {gr} n-dimensional array of grouping objects.
%              {idx} any indexing compatible with the dimensions of {gr},
%                   in the form of a string. Any Matlab indexing form can
%                   be used, including ':' and 'end'.
% Output:      {gr} the extracted sub-array of instances.
% Example:     Let {gr} be a 3-by-5 matrix of groupings. Then,
%              instance(gr,'1:2,1:2') will give the 2-by-2 submatrix of
%              groupings, while instance(gr,'3,5') will give a single
%              instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 04-Jul-2004

% parse input line
error(chkvar(idx,'char','vector',{mfilename,inputname(2),2}));

% return subgrouping
eval(['gr = gr(' idx ');']);