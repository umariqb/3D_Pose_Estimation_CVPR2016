function no_samples = nosamples(ds,which_var)

% NOSAMPLES number of samples in the different variables.
% -------------------------------------
% no_samples = nosamples(ds, which_var)
% -------------------------------------
% Description: number of samples in the different variables. As a dataset
%              may hold variables with different number of samples, we may
%              specify which variable are we interested in.
% Input:       {ds} dataset instance(s).
%              <{which_var}> specify which variable we should refer to when
%                   querying about number of samples. It can be a vector of
%                   variable indices. [] or 'all' indicate all variables.
%                   If absent, the result is the number of samples that is
%                   common to the majority of variables (ties are breaked
%                   arbitrarily).
% Output:      {no_samples} for scalar {ds}, it would be a vector carrying
%                   the number of samples in the corresponding variable(s).
%                   If {ds} is an array, {no_samples} would be a cell
%                   array, each entry holds the result of the corresponding
%                   dataset.
% Example:     Let {ds} be a dataset with four variables, comprising of 45,
%              45, 100, and 45 samples, respectively. Then
%                   nosamples(ds)       :-> 45
%                   nosamples(ds,[])    :-> [45 45 100 45]
%                   nosamples(ds,2:3)   :-> [45 100]

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% parse input
error(nargchk(1,2,nargin));
error(chkvar(ds,{},'vector',{mfilename,inputname(1),1}));

% loop on dataset
len = length(ds);
no_samples = cell(1,len);
for ii = 1:len
    dsii = instance(ds,num2str(ii));
    no_samples{ii} = nosamples(dsii.variables);
end

% get the requested information from {no_samples}
if nargin == 1      % majority rule
    for ii = 1:len
        no_samples{ii} = majority(no_samples{ii});
    end
else
    if ~isa(which_var,'char') && ~isempty(which_var)   % specific variables
        for ii = 1:len
            no_samples{ii} = no_samples{ii}(which_var);
        end
    end
end

% turn result into vector in case of a scalar {ds}
if len == 1
    no_samples = no_samples{1};
end