function lt = set(lt,varargin)

% SET set method
% -----------------------------------------------
% lt = set(lt, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {lt} lintrans instance.
%              {property_name},{property_value} legal pairs.
% Output:      {lt} updated lintrans instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 03-Feb-2005

% first argument is assured to be the datamatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(lt);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'type'     % field: type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).type = varargin{ii+1};
            end
        case 'u   '     % field: U
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).U = varargin{ii+1};
                lt(jj).no_factors = size(varargin{ii+1},2);
                lt(jj).no_variables = size(varargin{ii+1},1);
            end
        case 'eigv'     % field: eigvals
            error(chkvar(varargin{ii+1},'numeric','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).eigvals = varargin{ii+1};
            end
        case 'f_ei'     % field: f_eigvals
            error(chkvar(varargin{ii+1},'numeric','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).f_eigvals = varargin{ii+1};
            end
        case 'fact'     % field: factorset
            error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).factorset = varargin{ii+1};
            end
        case 'no_f'     % field: no_factors
            error('NO_FACTORS: field is read-only');
        case 'vari'     % field: variableset
            error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).variableset = varargin{ii+1};
            end
        case 'no_v'     % field: no_variables
            error('NO_VARIABLES: field is read-only');
        case 'no_s'     % field: no_samples
            error(chkvar(varargin{ii+1},'integer','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).no_samples = varargin{ii+1};
            end
        case 'prep'     % field: preprocess
            error(chkvar(varargin{ii+1},'struct','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).preprocess = varargin{ii+1};
            end
        case 'scor'     % field: scores
            error(chkvar(varargin{ii+1},'vsmatrix','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                lt(jj).scores = varargin{ii+1};
            end
        otherwise
            error('%s: not a field of LINTRANS',upper(varargin{ii}));
    end
end