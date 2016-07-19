function ct = ctable(varargin)

% CTABLE constructor method
% ---------------------------------------------
% (1) ct = ctable()
% (2) ct = ctable(no_instances)
% (3) ct = ctable(ct0)
% (4) ct = ctable(field_name, field_value, ...)
% (5) ct = ctable(category_1, category_2)
% (6) ct = ctable(table)
% ---------------------------------------------
% Description: constructs CTABLE instance(s).
% Input:       (1) An empty default CTABLE is formed.
%              (2) {no_instances} integer. In this case {ct} would be an
%                  empty CTABLE vector of length {no_instances}.
%              (3) {ct0} CTABLE instance. In this case {ct} would be
%                  an identical copy.
%              (4) pairs of field names accompanied by their corresponding
%                  values. Supported fields are all write-permission ones.
%              (5) {category_1} is eigher a 1-level grouping instance or a
%                       nominal variable. Anyway, it should function as
%                       means to split the data into several distinct
%                       classes.
%                  {category_2} is like {category_1}, but the splitting of
%                       the data is done according to a different criterion
%                       or variable.
%              (6) {table} is any matrix to represent the CTABLE.
% Output:      {ct} CTABLE instance(s).

% © Liran Carmel
% Classification: Constructors
% Last revision date: 28-Apr-2006

% decide on which kind of constructor should be used
if nargin == 0      % case (1)
    vvm = vvmatrix;             % parent class
    vvm = set(vvm,'type','Contingency');
    ct.indices = [];            % indices of samples in each cell
    ct.row_name = '';           % name of row-variable
    ct.col_name = '';           % name of col-variable
    ct = class(ct,'ctable',vvm);
elseif nargin == 1
    if isa(varargin{1},'double')
        if nodims(varargin{1}) == 1     % case (2)
            ct = [];
            for ii = 1:varargin{1}
                ct = [ct ctable];
                ct(ii).name = sprintf('Contingency Table #%d',ii);
            end
        else                            % case (6)
            ct = ctable;
            ct = set(ct,'matrix',varargin{1});
        end
    elseif isa(varargin{1},'ctable') % case (3)
        ct = varargin{1};
    else
        error('Unrecognized input argument');
    end
else
    if isa(varargin{1},'char')  % case (4)
        % use SET
        ct = ctable;
        ct = set(ct,varargin{:});
    else    % case (5)
        % parse input line
        error(nargchk(2,2,nargin));
        error(chkvar(varargin{1},{'grouping','variable'},'scalar',...
            {mfilename,'',1}));
        error(chkvar(varargin{2},{'grouping','variable'},'scalar',...
            {mfilename,'',2}));
        gr1 = grouping(varargin{1});
        gr2 = grouping(varargin{2});
        % initialize
        ct = ctable;
        % check consistency
        no_samples  = nosamples(gr1);
        if nosamples(gr2) ~= no_samples
            error('The categories should have the same number of samples');
        end
        if nohierarchies(gr1) > 1 || nohierarchies(gr2) > 1
            error('Both categories should have a single hierarchy');
        end
        % get names
        row_name = gr1.name;
        col_name = gr2.name;
        name = sprintf('%s - %s',row_name,col_name);
        % get row and col sampleset
        row_sampleset = sampleset(gr1.naming{1});
        col_sampleset = sampleset(gr2.naming{1});
        % compute 'matrix' and 'indices'
        no_rows = nogroups(gr1);
        no_cols = nogroups(gr2);
        indices = cell(no_rows,no_cols);
        matrix = zeros(no_rows,no_cols);
        gids1 = gr1.gcn2gid{1};
        gids2 = gr2.gcn2gid{1};
        for ii = 1:no_rows
            samp1 = grp2samp(gr1,gids1(ii));
            for jj = 1:no_cols
                indices(ii,jj) = ...
                    {intersect(samp1,grp2samp(gr2,gids2(jj)))};
                matrix(ii,jj) = length(indices{ii,jj});
            end
        end
        % set everything
        ct = set(ct,'name',name','row_sampleset',row_sampleset,...
            'col_sampleset',col_sampleset,'matrix',matrix,...
            'indices',indices,'row_name',row_name,'col_name',col_name);
    end
end