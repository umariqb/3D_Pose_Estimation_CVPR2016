function ss = instance(ss,idx)

% INSTANCE extracts a specific instance from a sampleset array.
% ----------------------
% ss = instance(ss, idx)
% ----------------------
% Description: extracts a specific instance from a sampleset array. It is
%              required to avoid ambiguity such as ss(2). In this case, if
%              {ss} is a vector, the returned value is a variable instance,
%              while if {ss} is a scalar, the returned value is the name
%              of the second sample in {ss}.
% Input:       {ss} n-dimensional array of sampleset objects.
%              {idx} any indexing compatible with the dimensions of {ss},
%                   in the form of a string. Any Matlab indexing form can
%                   be used, including ':' and 'end'.
% Output:      {ss} the extracted sub-array of instances.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 24-Sep-2004

% parse input line
error(chkvar(idx,'char','vector',{mfilename,inputname(2),2}));

% return subvariable
eval(['ss = ss([' idx ']);']);