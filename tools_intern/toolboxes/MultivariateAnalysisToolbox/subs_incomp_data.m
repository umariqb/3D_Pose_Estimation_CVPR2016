function data = subs_incomp_data(data_given,idx_given,max_idx)

% SUBS_INCOMP_DATA substitue given data in an incompleted data array
% -------------------------------------------------------
% data = subs_incomp_data(data_given, idx_given, max_idx)
% -------------------------------------------------------
% Description: Let {data_given} be a complete or incomplete data matrix of
%              dimensions {rows}-by-{cols}, provided for the samples
%              indexed by {idx_given}, which should be a vector of length
%              {cols}. {data} is an array of dimensions {rows}-by-{max_idx}
%              (where {max_idx} should not be lower than {cols}), in which
%              we substitue {data_given} in the appropriate places. All the
%              other data entries are filled with NaNs, to indicate missing
%              values.
% Input:       {data_given} data array of dimensions {rows}-by-{cols}.
%              {idx_given} list of samples, a vector of length {cols}.
%              {max_idx} is the total number of samples in {data}.
% Output:      {data} data array of dimensions {rows}-by-{max_idx}, with
%                   non-provided entries being NaNs.

% © Liran Carmel
% Classification: Data manipulations
% Last revision date: 09-Feb-2004

% check validity of input variables
error(nargchk(3,3,nargin));
[rows cols] = size(data_given);
error(chkvar(idx_given,'integer',{'vector',{'size',[1 cols]}},{mfilename,inputname(2),2}));
if max_idx < cols
    error('{max_idx} should be greater than {cols}')
end

% initialize all data points as if they are missing values
data = nan*ones(rows,max_idx);

% substitute nonmissing values
for ii = 1:rows
    data(ii,idx_given) = data_given(ii,:);
end