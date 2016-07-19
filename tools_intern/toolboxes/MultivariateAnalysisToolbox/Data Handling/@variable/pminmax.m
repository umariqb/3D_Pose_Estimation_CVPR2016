function mnmx = pminmax(vr)

% PMINMAX retrieves the population minmax values of a variable.
% ------------------
% mnmx = pminmax(vr)
% ------------------
% Description: retrieves the population minmax values of a variable.
% Input:       {vr} variable instance(s).
% Output:      {mnmx} populatin minmax values in each of the instances in
%                   {vr}. If {vr} is of length {n}, than {mnmx} will be of
%                   size 2-by-{n}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 30-Aug-2004

% parse input
error(chkvar(vr,{},'vector',{mfilename,inputname(1),1}));

% initialize
mnmx = zeros(2,length(vr));

% loop on all instances
for ii = 1:length(vr)
    mnmx(:,ii) = vr(ii).minmax.population';
end