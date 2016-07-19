function idx = sampid(ss,list)

% SAMPID finds the IDs of a list of samples.
% ----------------------
% idx = sampid(ss, list)
% ----------------------
% Description: finds the IDs of a list of samples.
% Input:       {ss} sampleset instance.
%              {list} cell array of sample names.
% Output:      {idx} consecutive numbers of the samples in {list}. NaN
%                   designates a name in {list} that does not exist in
%                   {ss}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 04-Oct-2004

% parse input
error(nargchk(2,2,nargin));
error(chkvar(ss,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(list,'cell',{},{mfilename,inputname(2),2}));

% initialize
idx = nan(1,length(list));
names = ss.sample_names;

% loop on all instances
for ii = 1:length(list)
    id = find(strcmp(list{ii},names),1);
    if ~isempty(id)
        idx(ii) = id;
    end
end