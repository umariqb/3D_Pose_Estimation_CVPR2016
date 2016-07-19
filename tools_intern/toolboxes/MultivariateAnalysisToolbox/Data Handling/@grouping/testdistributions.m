function [p_val, g_bin, g_names, p_enrich] = testdistributions(varargin)

% TESTDISTRIBUTIONS tests whether grouping distributions are different.
% ------------------------------------------------------------------------
% [p_val g_bin g_names p_enrich] = ...
%                  testdistributions(gr1, h1, gr2, h2, p_name, p_val, ...)
% ------------------------------------------------------------------------
% Description: tests whether grouping distributions are different.
%              Optinally, fine comparison can be made, testing which groups
%              are significantly enriched in either of the two groupings.
% Input:       {gr1} first GROUPING instance.
%              {h1} hierarchy level of {gr1}.
%              {gr2} second GROUPING instance.
%              {h2} hierarchy level of {gr2}.
%              <{p_name, p_val}> pair to modify the comparison. Currently
%                   available:
%                   'noSamples' - if 'equal', then the total number of
%                       samples in both groupings is expected to be
%                       identical. If 'nonequal', then the total number of
%                       samples is considered non-equal among the two
%                       groupings, even if it equals in practice. By
%                       default, the number of samples is assumed equal.
%                   'testEnrichment' - if 'on' tests for each class if it
%                       is enriched in one of the groupings. Default is
%                       'off'.
%                   'report' - if 'on' (default) generates a report.
% Output:      {p_val} p-value for testing if the distribution of the
%                   two groupings are different.
%              {g_bin} binned groupings {no_groups}-by-2.
%              {g_names} SAMPLESET instance containing the names of the
%                   {no_groups} groups.
%              {p_enrich} p-values for testing enrichment.

% © Liran Carmel
% Classification: Inference
% Last revision date: 01-Mar-2005

% parse input line
[gr1 gr2 is_equal test_enrich report] = parseInput(varargin{:});

% extract relevant grouping information
naming1 = gr1.naming{1};
naming2 = gr2.naming{1};
naming = union(naming1,naming2);
g_names = sampleset('name','Group Names','sample_names',naming);
no_groups = length(naming);

% generate binned distributions
g_bin = zeros(no_groups,2);
gs1 = groupsize(gr1);
for ii = 1:length(gs1)
    idx = strmatch(char(naming1{ii}),naming,'exact');
    g_bin(idx,1) = gs1(ii);
end
gs2 = groupsize(gr2);
for ii = 1:length(gs2)
    idx = strmatch(char(naming2{ii}),naming,'exact');
    g_bin(idx,2) = gs2(ii);
end

% test identity of distributions
if is_equal
    stat = sum( (g_bin(:,1) - g_bin(:,2)).^2 ./ sum(g_bin,2) );
    dof = no_groups - 1;
else
    no_samples = sum(g_bin,1);
    stat = sum( ( sqrt(no_samples(1)/no_samples(2)) * g_bin(:,2) - ...
        sqrt(no_samples(2)/no_samples(1)) * g_bin(:,1) ).^2 ./ ...
        sum(g_bin,2) );
    dof = no_groups;
end
p_val = 1 - chi2cdf(stat,dof);

% report
if report
    str = 'Null Hypothesis: class labels distribution is the same for';
    str = sprintf('%s groupings %s and %s.',str,gr1.name,gr2.name);
    str = sprintf('%s Result: P = %f.',str,p_val);
    disptext(str,60,0,17);
end

% test for enrichments
if test_enrich
    p_enrich = zeros(1,no_groups);
    g_enrich = zeros(1,no_groups);
    grp_sum = sum(g_bin,1);
    tot_sum = sum(grp_sum);
    for ii = 1:no_groups
        p0 = sum(g_bin(ii,:)) / tot_sum;
        if g_bin(ii,1)/grp_sum(1) > g_bin(ii,2)/grp_sum(2)
            g_enrich(ii) = 1;
            p_enrich(ii) = testbinom(g_bin(ii,1),grp_sum(1),p0,'p>p0');
        else
            g_enrich(ii) = 2;
            p_enrich(ii) = testbinom(g_bin(ii,2),grp_sum(2),p0,'p>p0');
        end
    end
    
    % report
    if report
        for ii = 1:no_groups
            str = 'Alternative Hypothesis:';
            str = sprintf('%s ''%s'' is enriched',str,char(g_names(ii)));
            if g_enrich(ii) == 1
                str = sprintf('%s in %s.',str,gr1.name);
            else
                str = sprintf('%s in %s.',str,gr2.name);
            end
            str = sprintf('%s Result: P = %f.',str,p_enrich(ii));
            disptext(str,60,3,20);
        end
    end
end

% #########################################################################
function [gr1, gr2, is_equal, test_enrich, report] = parseInput(varargin)

% PARSEINPUT parses input line.
% ------------------------------------------------------------
% [gr1 gr2 is_equal test_enrich report] = parseInput(varargin)
% ------------------------------------------------------------
% Description: parses the input line.
% Input:       {varargin} original input line.
% Output:      {gr1} single-hierarchy instance of GROUPING.
%              {gr2} single-hierarchy instance of GROUPING.
%              {is_equal} TRUE if number of samples is equal.
%              {test_enrich} TRUE if enrichment test is required.
%              {report} TRUE if a report is requested.

% check number of input arguments
error(nargchk(4,Inf,nargin));

% first two arguments define {gr1}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
gr1 = varargin{1};
gr1 = isolate(gr1,[1 varargin{2}]);

% next two arguments define {gr2}
error(chkvar(varargin{3},{},'scalar',{mfilename,'',1}));
gr2 = varargin{3};
gr2 = isolate(gr2,[1 varargin{4}]);

% defaults
is_equal = true;
test_enrich = false;
report = true;

% loop on instructions
for ii = 5:2:nargin
    errmsg = {mfilename,'',ii+1};
    switch str2keyword(varargin{ii},6)
        case 'noSamp'   % instruction: noSamples
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},3)
                case 'equ'
                    is_equal = true;
                case 'non'
                    is_equal = false;
                otherwise
                    error('%s: undefined option of ''noSamples''',...
                        varargin{ii+1});
            end
        case 'testen'   % instruction: testEnrichment
            error(chkvar(varargin{ii+1},'char','vector',errmsg));
            switch str2keyword(varargin{ii+1},2)
                case 'on'
                    test_enrich = true;
                case 'of'
                    test_enrich = false;
                otherwise
                    error('%s: undefined option of ''testEnrichment''',...
                        varargin{ii+1});
            end
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

% test consistency
if is_equal && nosamples(gr1) ~= nosamples(gr2)
    error('Number of samples in the two groups is not identical');
end