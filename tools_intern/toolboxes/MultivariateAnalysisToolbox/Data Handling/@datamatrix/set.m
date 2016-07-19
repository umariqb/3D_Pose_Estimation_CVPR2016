function dm = set(dm,varargin)

% SET set method
% -----------------------------------------------
% dm = set(dm, property_name, property_value,...)
% -----------------------------------------------
% Description: sets field values.
% Input:       {dm} datamatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {dm} updated datamatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% first argument is assured to be the datamatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(dm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)
        case 'name'     % field: name
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                % do not allow empty name
                if isempty(varargin{ii+1})
                    dm(jj).name = 'unnamed';
                else
                    dm(jj).name = varargin{ii+1};
                end
            end
        case 'desc'     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dm(jj).description = varargin{ii+1};
            end
        case 'sour'     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dm(jj).source = varargin{ii+1};
            end
        case 'type'     % field: type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dm(jj).type = varargin{ii+1};
            end
        case 'row_'     % field: row_type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dm(jj).row_type = varargin{ii+1};
            end
        case 'no_r'     % field: no_rows
            error('NO_ROWS: field is read-only');
        case 'col_'     % field: col_type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dm(jj).col_type = varargin{ii+1};
            end
        case 'no_c'     % field: no_cols
            error('NO_COLS: field is read-only');
        otherwise
            error('%s: not a field of DATAMATRIX',upper(varargin{ii}));
    end
end