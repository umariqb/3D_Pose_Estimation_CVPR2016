function sim = set(sim,varargin)

% SET set method
% -------------------------------------------------
% sim = set(sim, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {sim} simatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {sim} updated simatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Jan-2005

% first argument is assured to be the ssmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(sim);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'sim_'     % field: sim_type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                sim(jj).sim_type = varargin{ii+1};
            end
        case 'no_v'     % field: no_variables
            error(chkvar(varargin{ii+1},'integer','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                sim(jj).no_variables = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                sim(jj).ssmatrix = set(sim(jj).ssmatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end