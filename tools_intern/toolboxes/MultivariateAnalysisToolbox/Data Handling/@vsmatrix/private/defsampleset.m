function ss = defsampleset(no_samples)

% DEFSAMPLESET generates default sampleset.
% -----------------------------
% ss = defsampleset(no_samples)
% -----------------------------
% Description: generates default sampleset.
% Input:       {no_samples} number of samples.
% Output:      {ss} default sampleset with samples named 'sample #%d'.

% © Liran Carmel
% Classification: Housekeeping functions
% Last revision date: 05-Jan-2005

% no input parsing - private directory

% generate a list
list = cell(1,no_samples);
for ii = 1:no_samples
    list{ii} = sprintf('sample #%d',ii);
end

% generate sampleset
ss = sampleset(list);