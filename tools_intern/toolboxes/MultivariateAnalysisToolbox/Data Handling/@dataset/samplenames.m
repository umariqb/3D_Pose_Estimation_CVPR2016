function samp_names = samplenames(ds,which_sampleset)

% SAMPLENAMES sample names of a specific sampleset.
% ---------------------------------------------
% samp_names = samplenames(ds, which_sampleset)
% ---------------------------------------------
% Description: returns cell array containing the sample names.
% Input:       {ds} dataset instance.
%              <{which_sampset}> specifices the sample sets to take
%                   (def = take all).
% Output:      {samp_names} cell array of names. If more than one sample
%                   set is requested, it would be a cell of cell arrays.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 29-Nov-2004

% parse input
error(chkvar(ds,{},'scalar',{mfilename,inputname(1),1}));
if nargin == 1
    which_sampleset = 1:ds.no_samplesets;
end

% get result
ss = samplesets(ds);
ss = instance(ss,num2str(which_sampleset));
samp_names = samplenames(ss);