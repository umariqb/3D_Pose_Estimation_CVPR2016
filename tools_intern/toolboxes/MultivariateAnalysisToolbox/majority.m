function [val, idx, freq] = majority(vec)

% MAJORITY finds the most frequent entry.
% ------------------------------
% [val idx freq] = majority(vec)
% ------------------------------
% Description: finds the most frequent entry.
% Input:       {vec} any numeric vector.
% Output:      {val} the value(s) that appear most frequently in {vec}.
%              {idx} the indices where {val} appears. If {val} is a vector
%                   of length {n}, than {idx} is a matrix of {n} rows.
%              {freq} the number of occurances of {val}.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 29-Sep-2004

% initialize
list_val = [];
list_idx = [];
list_freq = [];

% loop on the vector entries
vec_tmp = vec;
while ~isempty(vec_tmp)
    list_val = [list_val vec_tmp(1)];
    idx = find(vec==list_val(end));
    list_idx = [list_idx {idx}];
    list_freq = [list_freq length(idx)];
    vec_tmp(vec_tmp==vec_tmp(1)) = [];
end

% find the most frequent entry
freq = max(list_freq);
f_idx = find(list_freq == freq);
val = list_val(f_idx);
idx = [];
for ii = 1:length(val)
    idx = [idx; list_idx{f_idx(ii)}];
end