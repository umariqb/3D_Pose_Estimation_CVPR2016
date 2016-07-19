function [h, h_rel] = entropy(vr)

% ENTROPY entropy of a variable.
% -----------------------
% [h h_rel] = entropy(vr)
% -----------------------
% Description: entropy of a variable, considering the observed frequency
%              of a value as its probability.
% Input:       {vr} group instance(s).
% Output:      {h} entropy of the variable(s).
%              {h_rel} entropy of the variable(s) divided by the maximal
%                   entropy possible, which is log2(no_groups).

% © Liran Carmel
% Classification: Characteristics of variable
% Last revision date: 30-Aug-2004

% parse input line
error(nargchk(1,1,nargin));

% initialize
h = zeros(1,length(vr));
h_rel = zeros(1,length(vr));

% loop on all variables
for ii = 1:length(vr)
    % extract data
    vrii = instance(vr,num2str(ii));
    data = nanless(vrii);
    % compute entropy
    p = [];
    n = 0;
    while ~isempty(data)
        idx = find(data == data(1));
        p = [p length(idx)];
        data(idx) = [];
        n = n + 1;
    end
    p = unit(p,1);
    h(ii) = entropy(p);
    if n > 1
        h_rel(ii) = h(ii) / log2(n);
    else
        h_rel(ii) = 0;
    end
end