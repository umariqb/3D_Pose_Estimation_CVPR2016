function xlswrite(varargin)

% XLSWRITE writes VVMATRIX data into an excel sheet.
% ---------------------------------
% xlswrite(vvm, i_name, i_val, ...)
% ----------------------------------
% Description: writes VVMATRIX data (matrix and variable names) into an
%              excel sheet.
% Input:       {vvm} VVMATRIX instance.
%              <{i_name, i_value}> pairs that instruct to determine
%                   properties of the output file.
%                   'file',file_name - determines the excel file name. By
%                       default, the file name is taken as the name of the
%                       VVMATRIX instance.
%                   'sheet',sheet_name - determines the excel sheet name.
%                       By default, the sheet name is taken as the name of
%                       the VVMATRIX instance.
%                   'range',range_string - determines the upper-left cell
%                       in Excel. By default it is 'A1'.
% Output:      an Excel file.

% © Liran Carmel
% Classification: I/O functions
% Last revision date: 08-Nov-2006

% parse input line
[vvm filename sheetname rng] = parseInput(varargin{:});

% find upper-left cell of three blocks of data
[row col] = rangeparts(rng);
row_plus = num2str(str2double(row) + 1);
col_plus = colnum2lett(collett2num(col) + 1);
left_rng = sprintf('%s%s',col,row_plus);
top_rng = sprintf('%s%s',col_plus,row);
main_rng = sprintf('%s%s',col_plus,row_plus);

% get row-variable and column-variables names
rowvars = samplenames(get(vvm,'row_sampleset'));
colvars = samplenames(get(vvm,'col_sampleset'));
mat = matrix(vvm);

% write to Excel {row-variables}-by-{col-variables}
warning('off','MATLAB:xlswrite:AddSheet');
xlswrite(filename,rowvars,sheetname,left_rng);
xlswrite(filename,colvars',sheetname,top_rng);
xlswrite(filename,mat,sheetname,main_rng);
warning('on','MATLAB:xlswrite:AddSheet');

% #########################################################################
function [vvm, filename, sheetname, rng] = parseInput(varargin)

% PARSEINPUT parses input line.
% ---------------------------------------------------
% [vsm filename sheetname rng] = parseInput(varargin)
% ---------------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {vvm} VVMATRIX instance.
%              {filename} name of Excel file.
%              {sheetname} name of sheet in Excel.
%              {rng} range.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vvm}
vvm = varargin{1};
error(chkvar(vvm,{},'scalar',{mfilename,'',1}));

% defaults
sheetname = get(vvm,'name');
filename = sprintf('%s.xls',sheetname);
rng = 'A1';

% loop on instructions
for ii = 2:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},4)
        case 'file'   % instruction: file
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            filename = varargin{ii+1};
        case 'shee'   % instruction: sheet
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            sheetname = varargin{ii+1};
        case 'rang'   % instruction: range
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            rng = varargin{ii+1};
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end