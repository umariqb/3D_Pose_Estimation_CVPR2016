function no_variables = novariables(ds,which_var)

% NOVARIABLES number of variables of a specific type.
% -----------------------------------------
% no_variables = novariables(ds, which_var)
% -----------------------------------------
% Description: number of variables of a specific type.
% Input:       {ds} dataset instance(s).
%              <{which_var}> specify which type of variables we are
%                   interested in. Can be 'nominal', 'ordinal',
%                   'numerical', 'unknown', or 'all' (def).
% Output:      {no_variables} a vector of the same size as {ds}, carrying
%                   the number of variables of each instance in {ds}.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 02-Sep-2004

% parse input
error(nargchk(1,2,nargin));
error(chkvar(ds,{},'vector',{mfilename,inputname(1),1}));
if nargin == 1
    which_var = 'all';
end

% initialize
no_variables = zeros(1,length(ds));

% find required index in no_variables field of dataset
keywords = {'nom','ord','num','unk','all'};
idx = strncmp(str2keyword(which_var,3),keywords,3);

% loop on all datasets
for ii = 1:length(ds)
    no_variables(ii) = ds(ii).no_variables(idx);
    %dsii = instance(ds,num2str(ii));
    %no_variables(ii) = dsii.no_variables(idx);
end