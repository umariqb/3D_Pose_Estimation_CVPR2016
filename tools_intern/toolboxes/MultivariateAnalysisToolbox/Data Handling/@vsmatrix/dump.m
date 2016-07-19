function dump(varargin)

% DUMP writes the VSMATRIX matrix into an excel sheet.
% -----------------------------
% dump(vsm, i_name, i_val, ...)
% -----------------------------
% Description: writes a VSMATRIX instance into an excel sheet.
% Input:       {vsm} VSMATRIX instance.
%              <{i_name, i_value}> pairs that instruct to determine
%                   properties of the output file.
%                   'file',file_name - determines the excel file name. By
%                       default, the file name is taken as the name of the
%                       VSMATRIX instance.
%                   'sheet',sheet_name - determines the excel sheet name.
%                       By default, the sheet name is taken as the name of
%                       the VSMATRIX instance.
%                   'range',range_string - determines the upper-left cell
%                       in Excel. By default it is 'A1'.
%                   'transpose','on'/'off' - by default (transpose =
%                       'off'), the matrix is plotted as
%                       {variables}-by-{samples}.
% Output:      an Excel file.

% © Liran Carmel
% Classification: I/O functions
% Last revision date: 02-Nov-2006

% hard coded parameters
TOP_SIZE = 200;
MAIN_SIZE = 1;

% parse input line
[vsm filename sheetname rng to_transpose] = parseInput(varargin{:});

% find upper-left cell of three blocks of data
[row col] = rangeparts(rng);
row_plus = num2str(str2double(row) + 1);
col_plus = colnum2lett(collett2num(col) + 1);
left_rng = sprintf('%s%s',col,row_plus);
top_rng = sprintf('%s%s',col_plus,row);
main_rng = sprintf('%s%s',col_plus,row_plus);

% get variable and sample names
sn = samplenames(vsm);
vn = variablenames(vsm);
mat = matrix(vsm);

% discrinimate between the two transposed versions
if to_transpose
    % {samples}-by-{variables}
    xlswrite(filename,sn',sheetname,left_rng);
    xlswrite(filename,vn,sheetname,top_rng);
    xlswrite(filename,mat',sheetname,main_rng);
else
    % {variables}-by-{samples}
    xlswrite(filename,vn',sheetname,left_rng);
    try
        xlswrite(filename,sn,sheetname,top_rng);
    catch
        for ii = 1:ceil(length(sn)/TOP_SIZE)
            % take only a part of the vector
            if length(sn) < TOP_SIZE
                sn_tmp = sn;
            else
                sn_tmp = sn(1:TOP_SIZE);
                sn(1:TOP_SIZE) = [];
            end
            xlswrite(filename,sn_tmp,sheetname,top_rng);
            % advance column
            col_plus = colnum2lett(collett2num(col_plus) + TOP_SIZE);
            top_rng = sprintf('%s%s',col_plus,row);
        end
    end
    try
        xlswrite(filename,mat,sheetname,main_rng);
    catch
        for ii = 1:ceil(size(mat,2)/MAIN_SIZE)
            % take only a part of the vector
            if size(mat,2) < MAIN_SIZE
                mat_tmp = mat;
            else
                mat_tmp = mat(:,1:MAIN_SIZE);
                mat(:,1:MAIN_SIZE) = [];
            end
            xlswrite(filename,mat_tmp,sheetname,main_rng);
            % advance column
            col_plus = colnum2lett(collett2num(col_plus) + MAIN_SIZE);
            main_rng = sprintf('%s%s',col_plus,row_plus);
        end
    end
end

% #########################################################################
function [vsm, filename, sheetname, rng, to_transpose] = ...
    parseInput(varargin)

% PARSEINPUT parses input line.
% ----------------------------------------------------------------
% [vsm filename sheetname rng to_transpose] = parseInput(varargin)
% ----------------------------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {vsm} VSMATRIX instance.
%              {filename} name of Excel file.
%              {sheetname} name of sheet in Excel.
%              {rng} range.
%              {to_transpose} binary variable determining whether to
%                   transpose the data matrix.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is always {vsm}
vsm = varargin{1};
error(chkvar(vsm,{},'scalar',{mfilename,'',1}));

% defaults
sheetname = get(vsm,'name');
filename = sprintf('%s.xls',sheetname);
rng = 'A1';
to_transpose = false;

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
        case 'tran'   % instruction: transpose
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},2)
                case 'on'
                    to_transpose = true;
                case 'of'
                    to_transpose = false;
                otherwise
                    error('%s: unfamiliar value for TRANSPOSE',...
                        varargin{ii+1});
            end
        otherwise
            error('%s: unfamiliar instruction',upper(varargin{ii}));
    end
end