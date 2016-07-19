function cvm = set(cvm,varargin)

% SET set method
% -------------------------------------------------
% cvm = set(cvm, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {cvm} covmatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {cvm} updated covmatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 17-Jan-2005

% first argument is assured to be the vvmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(cvm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},6)
        case 'cov_ty'   % field: cov_type
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                cvm(jj).cov_type = varargin{ii+1};
            end
        case 'no_sam'   % field: no_samples
            error(chkvar(varargin{ii+1},'integer','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                cvm(jj).no_samples = varargin{ii+1};
            end
        case 'hypoth'   % field: hypothesis
            error(chkvar(varargin{ii+1},{'char','cell'},'vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                if iscell(varargin{ii+1})
                    cvm(jj).hypothesis = varargin{ii+1};
                else
                    cvm(jj).hypothesis = cellstr(varargin{ii+1});
                end
            end
        case 'p_valu'   % field: p_value
            error(chkvar(varargin{ii+1},{'numeric','cell'},'matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                if iscell(varargin{ii+1})
                    cvm(jj).p_value = varargin{ii+1};
                else
                    cvm(jj).p_value = {varargin{ii+1}};
                end
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                cvm(jj).vvmatrix = set(cvm(jj).vvmatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end