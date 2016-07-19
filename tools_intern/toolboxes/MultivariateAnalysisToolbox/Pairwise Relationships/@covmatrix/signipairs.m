function signipairs(varargin)

% SIGNIPAIRS reports pairs that are significantly dependent.
% ----------------------------------
% signipairs(cvm, alpha, hypothesis)
% ----------------------------------
% Description: reports those pair of variables that pass the independence
%              test in a significant manner.
% Input:       {cvm} covmatrix instance.
%              <{alpha}> confidence level (def = 0.05).
%              <{hypothesis}> type of hypothesis testing
%                   (def = 'independence (t-test)').
% Output:      reports on the screen the list of significant pairs.

% © Liran Carmel
% Classification: Statistical computations
% Last revision date: 25-Jul-2006

% parse input line
[cvm idx alpha] = parse_input(varargin{:});

% check that test results are present
if isempty(idx)
    fprintf(1,'The required test was not performed.\n');
    return;
end

% get p_value
pv = cvm.p_value{idx};

% loop on all pairs
if get(cvm,'isroweqcol')
    ss = get(cvm,'sampleset');
    no_variables = nosamples(ss);
    for row = 1:(no_variables-1)
        for col = (row+1):no_variables
            if pv(row,col) < alpha
                fprintf(1,'%s and %s are not independent (P = %.4f)\n',...
                    char(ss(row)),char(ss(col)),pv(row,col));
            end
        end
    end
else
    ss_row = get(cvm,'row_sampleset');
    ss_col = get(cvm,'col_sampleset');
    for row = 1:nosamples(ss_row)
        for col = 1:nosamples(ss_col)
            if pv(row,col) < alpha
                fprintf(1,'%s and %s are not independent (P = %g)\n',...
                    char(ss(row)),char(ss(col)),pv(row,col));
            end
        end
    end
end

% #########################################################################
function [cvm, idx, alpha] = parse_input(varargin)

% PARSE_INPUT parses input line.
% ---------------------------------------
% [cvm idx alpha] = parse_input(varargin)
% ---------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {cvm} COVMATRIX object.
%              {idx} index of the p_value matrix corresponding to the
%                   desired test.
%              {alpha} condifence level.

% verify number of arguments
error(nargchk(1,3,nargin));

% first argument is always the COVMATRIX
cvm = varargin{1};
error(chkvar(cvm,{},'scalar',{mfilename,inputname(1),1}));

% set defaults
alpha = 0.05;
test = 'independence (t-test)';

% loop on the arguments
for ii = 2:nargin
    errmsg = {mfilename,'',ii};
    [msg1 is_char] = chkvar(varargin{ii},'char','vector',errmsg);
    if is_char
        test = varargin{ii};
    else
        [msg2 is_val] = chkvar(varargin{ii},'double',...
            {'scalar',{'eqgreater',0},{'eqlower',1}},errmsg);
        if is_val
            alpha = varargin{ii};
        else
            error('%s\n%s',msg1,msg2);
        end
    end
end

% compute index of appropriate p_value
idx = strmatch(test,cvm.hypothesis);