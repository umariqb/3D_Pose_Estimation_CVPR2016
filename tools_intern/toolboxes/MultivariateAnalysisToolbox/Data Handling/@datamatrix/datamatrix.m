function dm = datamatrix(varargin)

% DATAMATRIX constructor method
% -------------------------------------------------
% (1) dm = datamatrix()
% (2) dm = datamatrix(no_instances)
% (3) dm = datamatrix(dm0)
% -------------------------------------------------
% Description: constructs a datamatrix instance.
% Input:       (1) An empty default datamatrix is formed, identified by
%                  having zero number of rows and columns.
%              (2) {no_instances} integer. In this case {dm} would be an
%                  empty datamatrix vector of length {no_instances}.
%              (3) {dm0} datamatrix instance. In this case {dm} would be an
%                  identical copy.
% Output:      {dm} an instance of the datamatrix class.

% © Liran Carmel
% Classification: Constructors
% Last revision date: 28-Sep-2004

error(nargchk(0,1,nargin));
switch nargin
    case 0
        dm.name = 'unnamed';
        dm.description = '';
        dm.source = '';
        dm.type = '';
        dm.row_type = '';           % samples/variables
        dm.no_rows = 0;
        dm.col_type = '';           % samples/variables
        dm.no_cols = 0;
        dm = class(dm,'datamatrix');
    case 1
        [msg1 is_dm] = chkvar(varargin{1},'datamatrix',{},{mfilename,'',1});
        if is_dm
            dm = varargin{1};
        else
            [msg2 is_len] = chkvar(varargin{1},'integer','scalar',...
                {mfilename,'',1});
            if is_len
                dm = [];
                for ii = 1:varargin{1}
                    dm = [dm datamatrix];
                    dm(ii).name = sprintf('Matrix #%d',ii);
                end
            else
                error('%s\n%s',msg1,msg2);
            end
        end
end