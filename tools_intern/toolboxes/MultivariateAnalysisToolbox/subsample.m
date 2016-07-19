function [sub_list, sub_idx] = subsample(full_list, no_subsamples)

% SUBSAMPLE picks up at random a subsample of a vector.
% ----------------------------------------------
% sub_list = subsample(full_list, no_subsamples)
% ----------------------------------------------
% Description: picks up at random a subsample of a vector. Basically, if we
%              have a vector of length {n}, we would like to obtain a
%              smaller vector, of length {no_subsamples}, which is a subset
%              of the original vector. The same entry cannot be drawn
%              twice.
% Input:       {full_list} a vector of length {n}.
%              {no_subsamples} the length of the subsampled vector.
% Output:      {sub_list} a subvector of {full_list}.
%              {sub_idx} the indices of the {sub_list} elements in
%                   {full_list}.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 08-Mar-2004

% initialization
rand('state',sum(100*clock));
sub_idx = [];
full_idx = 1:length(full_list);

% start drawing
while no_subsamples
    tmp_idx = 1 + floor(length(full_idx)*rand(1,no_subsamples));
    tmp_idx = unique(tmp_idx);
    sub_idx = [sub_idx full_idx(tmp_idx)];
    full_idx(tmp_idx) = [];
    no_subsamples = no_subsamples - length(tmp_idx);
end

% arrange indices by increasing order
sub_idx = sort(sub_idx);

% take the corresponding vecotr values
sub_list = full_list(sub_idx);