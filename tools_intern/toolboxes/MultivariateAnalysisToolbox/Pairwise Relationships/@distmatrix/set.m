function dstm = set(dstm,varargin)

% SET set method
% ---------------------------------------------------
% dstm = set(dstm, property_name, property_value,...)
% ---------------------------------------------------
% Description: sets field values.
% Input:       {dstm} distmatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {dstm} updated distmatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Jan-2005

% first argument is assured to be the ssmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(dstm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},4)        
        case 'dist'
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dstm(jj).dist_type = varargin{ii+1};
            end
        case 'no_v'
            error(chkvar(varargin{ii+1},'integer','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                dstm(jj).no_variables = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                dstm(jj).ssmatrix = set(dstm(jj).ssmatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end