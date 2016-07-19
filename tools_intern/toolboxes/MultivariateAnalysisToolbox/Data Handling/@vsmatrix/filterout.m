function vsm = filterout(vsm,entity,filter_name,varargin)

% FILTEROUT filters out variables or samples.
% ------------------------------------------------------
% vsm = filterout(vsm, entity, filter_name, p1, p2, ...)
% ------------------------------------------------------
% Description: filters out variables or samples.
% Input:       {vsm} instance of the VSMATRIX class.
%              {entity} either 'samples' or 'variables'.
%              {filter_name},{p1,p2,...} identifies to filter to operate.
%                   Currently available are:
%                   'lowvariance' - removes variables whose variance equals
%                       or is below {p1}.
% Output:      {vsm} updated VSMATRIX.

% © Liran Carmel
% Classification: Transformations
% Last revision date: 24-Oct-2005

% parse input line
error(nargchk(3,Inf,nargin));
error(chkvar(vsm,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(entity,'char',{{'match',{'samples','variables'}}},...
    {mfilename,inputname(2),2}));
error(chkvar(filter_name,'char',{},{mfilename,inputname(3),3}));

% switch on filter
switch str2keyword(filter_name,6)
    case 'lowvar'
        % process input
        if length(varargin{1}) > 1
            error('Too many input arguments')
        end
        error(chkvar(varargin{1},'numeric','scalar',{mfilename,[],4}));
        % find variables to remove
        vari = var(vsm.variables);
        to_remove = find(vari <= varargin{1});
        if isempty(to_remove)
            % generate report
            fprintf(1,['all variables have their variance '...
                'above %g\n'],varargin{1});
        else
            fprintf(1,['%d variables had their variance '...
                'lower or equal to %g:\n'],length(to_remove),varargin{1});
            for ii = 1:length(to_remove)
                fprintf(1,'   %s\n',vsm.variables(to_remove(ii)).name);
            end
            vsm = deletevariables(vsm,to_remove);
        end
    otherwise
        error('%s: unrecognized filter',filter_name);
end