function binvar = eq(ss,another_ss)

% EQ element-wise logical operator.
% ---------------------------
% binvar = (ss == another_ss)
% ---------------------------
% Description: An equality between two samplesets is defined if they carry
%              exactly the same samples in the same order.
% Input:       {ss} sampleset instance.
%              {another_ss} another sampleset instance.
% Output:      {binvar} resulting logical vector.

% © Liran Carmel
% Classification: Operators
% Last revision date: 01-Dec-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(another_ss,'sampleset',{},{mfilename,inputname(2),2}));

% at least one of {ss} or {another_ss} should be scalar, or they both match
% in dimensions
if isscalar(ss)     % {ss} is scalar
    binvar = false(size(another_ss));
    for ii = 1:numel(another_ss)
        binvar(ii) = scalareq(ss,instance(another_ss,num2str(ii)));
    end
else
    if isscalar(another_ss)     % {another_ss} is scalar but {ss} is not
        binvar = false(size(ss));
        for ii = 1:numel(ss)
            binvar(ii) = scalareq(another_ss,ss(ii));
        end
    elseif size(ss) == size(another_ss)     % both are same-size nonscalars
        binvar = false(size(ss));
        for ii = 1:numel(ss)
            binvar(ii) = scalareq(another_ss(ii),ss(ii));
        end
    else    % different-size nonscalars
        error('%s and %s do not match in dimensions',inputname(1),...
            inputname(2));
    end
end

% #########################################################################
function binvar = scalareq(ss1,ss2)

% SCALAREQ checks equality between two scalar samplesets.
% ---------------------------
% binvar = scalareq(ss1, ss2)
% ---------------------------
% Description: checks equality between two scalar samplesets.
% Input:       {ss1} first sampleset.
%              {ss2} second sampleset.
% Output:      {binvar} either true or false.

if nosamples(ss1) ~= nosamples(ss2)
    binvar = false;
elseif ~all(strcmp(samplenames(ss1),samplenames(ss2)))
    binvar = false;
else
    binvar = true;
end