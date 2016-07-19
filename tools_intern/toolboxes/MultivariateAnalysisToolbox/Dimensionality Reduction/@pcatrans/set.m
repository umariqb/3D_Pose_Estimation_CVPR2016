function pt = set(pt,varargin)

% SET set method
% -----------------------------------------------
% pt = set(pt, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {pt} pcatrans instance.
%              {property_name},{property_value} legal pairs.
% Output:      {pt} updated pcatrans instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the pcatrans. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(pt);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'algo'     % field: algorithm
            error(chkvar(varargin{ii+1},'char',...
                {{'match',{'cov','svd'}}},errmsg));
            % loop on instances
            for jj = 1:no_instances
                pt(jj).algorithm = varargin{ii+1};
            end
        case 'orth'     % field: ortho_constraints
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                pt(jj).ortho_constraints = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                pt(jj).lintrans = set(pt(jj).lintrans,...
                    varargin{ii},varargin{ii+1});
            end
    end
end