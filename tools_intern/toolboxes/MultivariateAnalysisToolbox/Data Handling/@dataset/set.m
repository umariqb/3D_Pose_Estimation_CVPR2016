function ds = set(ds,varargin)

% SET set method.
% ------------------------------------------------
% ds = set(ds, property_name, property_value, ...)
% ------------------------------------------------
% Description: sets field values.
% Input:       {ds} dataset instance.
%              {property_name},{property_value} legal pairs.
% Output:      {ds} updated dataset instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 07-Jan-2005

% first argument is assured to be the dataset. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(ds);
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
                    ds(jj).name = 'unnamed';
                else
                    ds(jj).name = varargin{ii+1};
                end
            end
        case 'desc'     % field: description
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).description = varargin{ii+1};
            end
        case 'sour'     % field: source
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).source = varargin{ii+1};
            end
        case 'vari'     % field: variables
            error(chkvar(varargin{ii+1},'variable','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).variables = varargin{ii+1};
                ds(jj).no_variables = [0 0 0 0 0];
                for kk = 1:length(varargin{ii+1})
                    switch ds(jj).variables(kk).level
                        case 'nominal'
                            ds(jj).no_variables = ds(jj).no_variables + ...
                                [1 0 0 0 1];
                        case 'ordinal'
                            ds(jj).no_variables = ds(jj).no_variables + ...
                                [0 1 0 0 1];
                        case 'numerical'
                            ds(jj).no_variables = ds(jj).no_variables + ...
                                [0 0 1 0 1];
                        case 'unknown'
                            ds(jj).no_variables = ds(jj).no_variables + ...
                                [0 0 0 1 1];
                    end
                end
                ds(jj).var2sampset = guessvar2sampset(ds(jj),[]);
            end
        case 'no_v'     % field: no_variables
            error('NO_VARIABLES: field is read-only');
        case 'grou'     % field: groupings
            error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).groupings = varargin{ii+1};
                ds(jj).no_groupings = length(varargin{ii+1});
                ds(jj).grp2sampset = guessgrp2sampset(ds(jj));
            end
        case 'no_g'     % field: no_groupings
            error('NO_GROUPINGS: field is read-only');
        case 'samp'     % field: samplesets
            error(chkvar(varargin{ii+1},'sampleset','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).samplesets = varargin{ii+1};
                ds(jj).no_samplesets = length(varargin{ii+1});
            end
        case 'no_s'     % field: no_samplesets
            error('NO_SAMPLESETS: field is read-only');
        case 'matr'     % field: matrix
            error(chkvar(varargin{ii+1},'cell','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).matrix = varargin{ii+1};
                ds(jj).no_matrices = length(varargin{ii+1});
            end
        case 'no_m'     % field: no_matrices
            error('NO_MATRICES: field is read-only');
        case 'var2'     % field: var2sampset
            error(chkvar(varargin{ii+1},'integer','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).var2sampset = varargin{ii+1};
            end
        case 'grp2'     % field: grp2sampset
            error(chkvar(varargin{ii+1},'integer','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ds(jj).grp2sampset = varargin{ii+1};
            end
        otherwise
            error('%s: not a field of DATASET',upper(varargin{ii}));
    end
end