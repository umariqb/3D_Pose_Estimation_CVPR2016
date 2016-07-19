function dsm = set(dsm,varargin)

% SET set method
% ---------------------------------------------------
% dsm = set(dsm, property_name, property_value,...)
% ---------------------------------------------------
% Description: sets field values.
% Input:       {dsm} dissimatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {dsm} updated dissimatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 10-Jan-2004

% first argument is assured to be the ssmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(dsm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'diss'     % field: dissim_type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dsm(jj).dissim_type = varargin{ii+1};
            end
        case 'no_v'     % field: no_variables
            error(chkvar(varargin{ii+1},'integer','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dsm(jj).no_variables = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                dsm(jj).ssmatrix = set(dsm(jj).ssmatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end