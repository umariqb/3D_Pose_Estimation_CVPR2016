function names = samplenames(vsm)

% SAMPLENAMES retrieves the sample names of vsmatrix.
% ------------------------
% names = samplenames(vsm)
% ------------------------
% Description: retrieves the sample names of vsmatrix.
% Input:       {vsm} vsmatrix instance(s).
% Output:      {names} sample names (cell array) in each of the instances
%                   in {vsm}. If {vsm} is not scalar, the lists are grouped
%                   in another cell array with the same dimensions as
%                   {vsm}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 27-Sep-2004

% if no sampleset exists
names = [];

% return
if ~isempty(vsm.sampleset)
    names = samplenames(vsm.sampleset);
end