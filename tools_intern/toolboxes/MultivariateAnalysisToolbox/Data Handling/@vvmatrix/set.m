function vvm = set(vvm,varargin)

% SET set method
% -------------------------------------------------
% vvm = set(vvm, property_name, property_value,...)
% -------------------------------------------------
% Description: sets field values.
% Input:       {vvm} vvmatrix instance.
%              {property_name},{property_value} legal pairs.
% Output:      {vvm} updated vvmatrix instance.

% © Liran Carmel
% Classification: SET/GET functions
% Last revision date: 04-Feb-2005

% first argument is assured to be the vvmatrix. parse property_name,
% property_value pairs
error(chkvar(nargin-1,{},'even',{mfilename,'List of properties',0}));
no_instances = numel(vvm);
for ii = 1:2:length(varargin)
    error(chkvar(varargin{ii},'char','vector',{mfilename,'',ii+1}));
    errmsg = {mfilename,'',ii+2};
    switch str2keyword(varargin{ii},6)
        case 'row_sa'       % field: row_sampleset
            % loop on instances
            for jj = 1:no_instances
                if ~isa(varargin{ii+1},'sampleset')
                    vvm(jj).row_sampleset = sampleset(varargin{ii+1});
                else
                    vvm(jj).row_sampleset = varargin{ii+1};
                end
                vvm(jj).sampleset = [];
                vvm(jj).isroweqcol = false;
                % 'no_rows' is determined only by 'matrix'
            end
        case 'col_sa'       % field: col_sampleset
            % loop on instances
            for jj = 1:no_instances
                if ~isa(varargin{ii+1},'sampleset')
                    vvm(jj).col_sampleset = sampleset(varargin{ii+1});
                else
                    vvm(jj).col_sampleset = varargin{ii+1};
                end
                vvm(jj).sampleset = [];
                vvm(jj).isroweqcol = false;
                % 'no_cols' is determined only by 'matrix'
            end
        case 'sample'       % field: sampleset
            % loop on instances
            for jj = 1:no_instances
                if ~isa(varargin{ii+1},'sampleset')
                    vvm(jj).sampleset = sampleset(varargin{ii+1});
                else
                    vvm(jj).sampleset = varargin{ii+1};
                end
                vvm(jj).row_sampleset = [];
                vvm(jj).col_sampleset = [];
                vvm(jj).isroweqcol = true;
                % 'no_cols' and 'no_rows' are determined only by 'matrix'
            end
        case 'matrix'       % field: matrix
            error(chkvar(varargin{ii+1},'numeric','matrix',errmsg));
            % loop on instances
            for jj = 1:no_instances
                vvm(jj).matrix = varargin{ii+1};
                vvm(jj).datamatrix = setnocols(vvm(jj).datamatrix,...
                    size(vvm(jj).matrix,2));
                vvm(jj).datamatrix = setnorows(vvm(jj).datamatrix,...
                    size(vvm.matrix,1));
            end
        case 'isrowe'       % field: isroweqcol
            error('ISROWEQCOL: field is read-only');
        otherwise
            % loop on instances
            for jj = 1:no_instances
                vvm(jj).datamatrix = set(vvm(jj).datamatrix,...
                    varargin{ii},varargin{ii+1});
            end
    end
end