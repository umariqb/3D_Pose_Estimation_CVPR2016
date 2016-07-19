function ct = set(ct,varargin)

% SET set method
% -------------------------------------------------
% ct = set(ct, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {ct} CTABLE instance.
%              {property_name},{property_value} legal pairs.
% Output:      {ct} updated CTABLE instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 16-Feb-2005

% first argument is assured to be the vvmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(ct);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},5)
        case 'indic'   % field: indices
            error(chkvar(varargin{ii+1},'cell','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ct(jj).indices = varargin{ii+1};
            end
        case 'row_n'   % field: row_name
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ct(jj).row_name = varargin{ii+1};
            end
        case 'col_n'   % field: col_name
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ct(jj).col_name = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                ct(jj).vvmatrix = set(ct(jj).vvmatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end