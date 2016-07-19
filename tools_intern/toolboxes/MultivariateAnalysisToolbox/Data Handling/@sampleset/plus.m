function ss1 = plus(ss1,ss2)

% PLUS adds names to the sample set.
% --------------
% ss = ss1 + ss2
% --------------
% Description: adds names to the sample set. {ss2} can be either a
%              SAMPLESET object or a list of names.
% Input:       {ss1} lefthand SAMPLESET instance.
%              {ss2} righthand SAMPLESET instance.
% Output:      {ss} unified SAMPLESET instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 30-Oct-2006

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(ss1,{},'scalar',{mfilename,inputname(1),1}));
if ~isa(ss2,'sampleset')
    ss2 = sampleset(ss2);
end
error(chkvar(ss2,{},'scalar',{mfilename,inputname(2),2}));

% add new names
names = ss1.sample_names;
idx = sampid(ss1,samplenames(ss2));
names = [names ss2.sample_names(isnan(idx))];
ss1 = set(ss1,'sample_names',names);