function ssm = set(ssm,varargin)

% SET set method
% -------------------------------------------------
% ssm = set(ssm, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {ssm} ssmatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {ssm} updated ssmatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 12-Aug-2005

% first argument is assured to be the ssmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(ssm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},6)
        case 'row_sa'       % field: row_sampleset
            if isa(varargin{ii+1},'cell')
                varargin{ii+1} = sampleset(varargin{ii+1});
            end
            error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).row_sampleset = varargin{ii+1};
                ssm(jj).sampleset = [];
                ssm(jj).isroweqcol = false;
                % 'no_rows' is determined only by 'matrix'
            end
        case 'col_sa'       % field: col_sampleset
            if isa(varargin{ii+1},'cell')
                varargin{ii+1} = sampleset(varargin{ii+1});
            end
            error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).col_sampleset = varargin{ii+1};
                ssm(jj).sampleset = [];
                ssm(jj).isroweqcol = false;
                % 'no_cols' is determined only by 'matrix'
            end
        case 'sample'       % field: sampleset
            if isa(varargin{ii+1},'cell')
                varargin{ii+1} = sampleset(varargin{ii+1});
            end
            error(chkvar(varargin{ii+1},'sampleset','scalar',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).sampleset = varargin{ii+1};
                ssm(jj).row_sampleset = [];
                ssm(jj).col_sampleset = [];
                ssm(jj).isroweqcol = true;
                % 'no_cols' and 'no_rows' are determined only by 'matrix'
            end
        case 'matrix'       % field: matrix
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).matrix = varargin{ii+1};
                ssm(jj).datamatrix = setnocols(ssm(jj).datamatrix,...
                    size(ssm(jj).matrix,2));
                ssm(jj).datamatrix = setnorows(ssm(jj).datamatrix,...
                    size(ssm.matrix,1));
            end
        case 'row_gr'       % field: row_groupings
            error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).row_groupings = varargin{ii+1};
                ssm(jj).groupings = [];
                % 'isroweqcol' is determined by the samplesets
            end
        case 'col_gr'       % field: col_groupings
            error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).col_groupings = varargin{ii+1};
                ssm(jj).groupings = [];
                % 'isroweqcol' is determined by the samplesets
            end
        case 'groupi'       % field: groupings
            error(chkvar(varargin{ii+1},'grouping','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).groupings = varargin{ii+1};
                ssm(jj).row_groupings = [];
                ssm(jj).col_groupings = [];
                % 'isroweqcol' is determined by the samplesets
            end
        case 'isrowe'       % field: isroweqcol
            error('ISROWEQCOL: field is read-only');
        case 'modifi'       % field: modifications
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).modifications = varargin{ii+1};
            end
        otherwise
            % loop on instances
            for jj = 1:no_instances
                ssm(jj).datamatrix = set(ssm(jj).datamatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end

% check consistency
for jj = 1:no_instances
    if ssm(jj).isroweqcol && (~isempty(ssm(jj).row_groupings) || ...
            ~isempty(ssm(jj).row_groupings))
        error(['different groupings were associated with the rows ' ...
            'and the columns of the matrix, while ISROWEQCOL ' ...
            'indicates that they are the same']);
    elseif ~ssm(jj).isroweqcol && ~isempty(ssm(jj).groupings)
        error(['Same groupings were associated with the rows ' ...
            'and the columns of the matrix, while ISROWEQCOL ' ...
            'indicates that they are different']);
    end
end