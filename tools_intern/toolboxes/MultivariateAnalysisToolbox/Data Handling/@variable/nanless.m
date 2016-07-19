function [data, idx] = nanless(vr)

% NANLESS extracts only complete data (without missing values).
% ------------------------
% [data idx] = nanless(vr)
% ------------------------
% Description: extracts only complete data (without missing values).
% Input:       {vr} instance of the variable class.
% Output:      {data} the non-missing data.
%              {idx} the indices of the non-missing data.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 24-Jun-2004

% check that input is scalar variable
error(chkvar(vr,{},'scalar',{mfilename,inputname(1),1}));

% extract nanless data
nan_idx = ~isnan(vr.data);
data = vr.data(nan_idx);
idx = 1:vr.no_samples;
idx = idx(nan_idx);