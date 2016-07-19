function vr = instance(vr,idx)

% INSTANCE extracts a specific instance from a variable array.
% ----------------------
% vr = instance(vr, idx)
% ----------------------
% Description: extracts a specific instance from a variable array. It is
%              required to avoid ambiguity such as vr(2). In this case, if
%              {vr} is a vector, the returned value is a variable instance,
%              while if {vr} is a scalar, the returned value is the second
%              data point in {vr}.
% Input:       {vr} n-dimensional array of variable objects.
%              {idx} any indexing compatible with the dimensions of {vr},
%                   in the form of a string. Any Matlab indexing form can
%                   be used, including ':' and 'end'.
% Output:      {vr} the extracted sub-array of instances.
% Example:     Let {vr} be a 3-by-5 matrix of variables. Then,
%              instance(vr,'1:2,1:2') will give the 2-by-2 submatrix of
%              variables, while instance(vr,'3,5') will give a single
%              instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 24-Sep-2004

% parse input line
error(chkvar(idx,'char','vector',{mfilename,inputname(2),2}));

% return subvariable
eval(['vr = vr([' idx ']);']);