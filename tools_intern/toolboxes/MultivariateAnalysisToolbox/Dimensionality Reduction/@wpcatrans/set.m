function wpt = set(wpt,varargin)

% SET set method
% -------------------------------------------------
% wpt = set(wpt, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {wpt} wpcatrans instance.
%              {property_name},{property_value} legal pairs.
% Output:      {wpt} updated wpcatrans instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the wpcatrans. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(wpt);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'orth'     % field: ortho_constraints
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                wpt(jj).ortho_constraints = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                wpt(jj).lintrans = set(wpt(jj).lintrans,...
                    varargin{ii},varargin{ii+1});
            end
    end
end