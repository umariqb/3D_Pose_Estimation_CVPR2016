function ds = instance(ds,idx)

% INSTANCE extracts a specific instance from a dataset array.
% ----------------------
% ds = instance(ds, idx)
% ----------------------
% Description: extracts a specific instance from a dataset array. It is
%              required to avoid ambiguity such as ds(2). In this case, if
%              {ds} is a vector, the returned value is a dataset instance,
%              while if {ds} is a scalar, the returned value is the second
%              assignment value of the first hierarchy.
% Input:       {ds} n-dimensional array of dataset objects.
%              {idx} any indexing compatible with the dimensions of {ds},
%                   in the form of a string. Any Matlab indexing form can
%                   be used, including ':' and 'end'.
% Output:      {ds} the extracted sub-array of instances.
% Example:     Let {ds} be a 3-by-5 matrix of datasets. Then,
%              instance(ds,'1:2,1:2') will give the 2-by-2 submatrix of
%              datasets, while instance(ds,'3,5') will give a single
%              instance.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 30-Aug-2004

% parse input line
error(chkvar(idx,'char','vector',{mfilename,inputname(2),2}));

% return subdataset
eval(['ds = ds(' idx ');']);