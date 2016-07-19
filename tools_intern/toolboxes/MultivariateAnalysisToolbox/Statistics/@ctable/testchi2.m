function p_val = testchi2(varargin)

% TESTCHI2 tests whether two categories are independent.
% ----------------------------------------
% p_val = testchi2(ct, p_name, p_val, ...)
% ----------------------------------------
% Description: tests whether two categories are independent.
% Input:       {ct} CTABLE instance.
%              <{p_name, p_val}> pair to modify the test. Currently
%                   available:
%                   'report' - if 'on' (default) displays a report.
% Output:      {p_val} p-value of the test.

% © Liran Carmel
% Classification: Statistical analysis
% Last revision date: 16-Feb-2005

% parse input line
[ct report] = parseInput(varargin{:});

% expected table
c_table = get(ct,'matrix');
n = sum2(c_table);
p_col = sum(c_table,1) / n;
p_row = sum(c_table,2) / n;
e_table = n*p_row*p_col;

% test statistic
chi2 = sum2( (c_table - e_table).^2 ./ e_table );

% find p-value
dof = (get(ct,'no_rows')-1) * (get(ct,'no_cols')-1);
p_val = 1 - chi2cdf(chi2,dof);

% report
if report
    str = sprintf('Null Hypothesis: %s is independent of %s.',...
        ct.row_name,ct.col_name);
    str = sprintf('%s Result: P = %f.',str,p_val);
    disptext(str,60,0,17);
end

% #########################################################################
function [ct, report] = parseInput(varargin)

% PARSEINPUT parses input line.
% ----------------------------------
% [ct report] = parseInput(varargin)
% ----------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {ct} CTABLE instance.
%              {report} TRUE if a report is requested.

% check number of input arguments
error(nargchk(1,Inf,nargin));

% first argument is {ct}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
ct = varargin{1};

% defaults
report = true;

% loop on instructions
for ii = 2:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},6)
        case 'report'   % instruction: report
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},2)
                case 'on'
                    report = true;
                case 'of'
                    report = false;
                otherwise
                    error('%s: undefined option of ''report''',...
                        varargin{ii+1});
            end
        otherwise
            error('%s: undefined instruction',varargin{ii});
    end
end