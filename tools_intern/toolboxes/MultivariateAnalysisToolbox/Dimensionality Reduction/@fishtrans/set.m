function ft = set(ft,varargin)

% SET set method
% -----------------------------------------------
% ft = set(ft, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {ft} fishtrans instance.
%              {property_name},{property_value} legal pairs.
% Output:      {ft} updated fishtrans instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 01-Feb-2005

% first argument is assured to be the fishtrans. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(ft);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'rati'     % field: ratio
            error(chkvar(varargin{ii+1},'char',...
                {{'match',{'Sb/Sw','Sb/St'}}},errmsg));
            % loop on instances
            for jj = 1:no_instances
                ft(jj).ratio = varargin{ii+1};
            end
        case 'orth'     % field: ortho_constraints
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ft(jj).ortho_constraints = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                ft(jj).lintrans = set(ft(jj).lintrans,...
                    varargin{ii},varargin{ii+1});
            end
    end
end