function ss = deletesamples(ss,to_remove)

% DELETESAMPLES eliminate samples from a sampleset instance(s).
% ---------------------------------
% ss = deletesamples(ss, to_remove)
% ---------------------------------
% Description: eliminate samples from a sampleset instance(s).
% Input:       {ss} sampleset instance(s).
%              {to_remove} samples to delete.
% Output:      {ss} updated sampleset instance(s).

% © Liran Carmel
% Classification: Operators
% Last revision date: 20-Sep-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(ss,{},'vector',{mfilename,inputname(1),1}));
error(chkvar(to_remove,'integer','vector',{mfilename,inputname(2),2}));

% delete samples
for ii = 1:length(ss)
    ss(ii).sample_names(to_remove) = [];
    ss(ii).no_samples = length(ss(ii).sample_names);
end