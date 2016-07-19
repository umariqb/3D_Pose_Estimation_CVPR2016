function slice(varargin)

% SLICE shows one grouping spliced by another.
% -------------------------------------------------------------
% slice(gr_base, g_base, h_base, gr_sliced, g_sliced, h_sliced)
% -------------------------------------------------------------
% Description: shows one grouping spliced by another.
% Input:       {gr_base} grouping instance which is base for slicing.
%              {g_base} which groups to take in {gr_base}. Can be a vector
%                   of group numbers, or the keyword 'all'.
%              <{h_base}> which hierarchy to take in {gr_base} (def = 1).
%              {gr_sliced} grouping instance which is sliced.
%              {g_sliced} which groups to take in {gr_sliced}. Can be a
%                   vector of group numbers, or the keyword 'all'.
%              <{h_sliced}> which hierarchy to take in {gr_sliced} (def =
%                   1).

% © Liran Carmel
% Classification: Visualization
% Last revision date: 02-Sep-2004

% parse input line
[gr_base g_base h_base gr_sliced g_sliced h_sliced] = ...
    parse_input(varargin{:});

% take only samples dictated by {g_base} and {g_sliced}
samp = intersect(grp2samp(gr_base,g_base,h_base),...
    grp2samp(gr_sliced,g_sliced,h_sliced));
to_remove = allbut(samp,nosamples(gr_base));
gr_base = deletesamples(gr_base,to_remove);
nog_base = nogroups(gr_base,h_base);
g_base = grpidnum(gr_base,h_base);
gr_sliced = deletesamples(gr_sliced,to_remove);
nog_sliced = nogroups(gr_sliced,h_sliced);
g_sliced = grpidnum(gr_sliced,h_sliced);

% generate the matrix to plot
m_slice = zeros(nog_base,nog_sliced);
for ii = 1:nog_base
    samp = grp2samp(gr_base,g_base(ii),h_base);
    grps = gr_sliced.assignment(h_sliced,samp);
    for jj = 1:nog_sliced
        m_slice(ii,jj) = sum(grps==g_sliced(jj));
    end
end

% plot
bar(m_slice)
legend(gr_sliced.naming{h_sliced})

% modify the x-axis ticks
MAX_NUM_OF_TEXT_TICKS = 30;
if nog_base > MAX_NUM_OF_TEXT_TICKS % no text ticks
    set(gca,'xtick',1:nog_base,'xticklabel',g_base);
else                                % text ticks
    set(gca,'xtick',1:nog_base,'xticklabel',gr_base.naming{h_base});
end

% #########################################################################
function [gr_base, g_base, h_base, gr_sliced, g_sliced, h_sliced] = ...
    parse_input(varargin)

% PARSE_INPUT parses input line.
% -------------------------------------------------------------------------
% [gr_base g_base h_base gr_sliced g_sliced h_sliced] = parse_input(varargin)
% -------------------------------------------------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr_base} grouping instance which is base for slicing.
%              {g_base} which groups to take in {gr_base}. Can be a vector
%                   of group numbers, or the keyword 'all'.
%              <{h_base}> which hierarchy to take in {gr_base} (def = 1).
%              {gr_sliced} grouping instance which is sliced.
%              {g_sliced} which groups to take in {gr_sliced}. Can be a
%                   vector of group numbers, or the keyword 'all'.
%              <{h_sliced}> which hierarchy to take in {gr_sliced} (def =
%                   1).

% verify number of arguments
error(nargchk(4,6,nargin));

% first argument is always {gr_base}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
gr_base = varargin{1};

% second argument is always {g_base}
is_all = false;
[msg1 is_int] = chkvar(varargin{2},'integer',{},{mfilename,'',2});
if is_int
    g_base = varargin{2};
else
    [msg2 is_all] = chkvar(varargin{2},'char',{},{mfilename,'',2});
    if ~is_all
        error('%s\n%s',msg1,msg2);
    end
end

% optional third argument
next_arg = 3;
[msg is_h] = chkvar(varargin{3},'integer',{});  %#ok
if is_h
    next_arg = 4;
    error(chkvar(varargin{3},{},{'scalar',{'eqlower',nohierarchies(gr_base)}},...
        {mfilename,'',3}));
    h_base = varargin{3};
else
    h_base = 1;
end

% check consistency of {g_base}
g_numb = grpidnum(gr_base,h_base);
if is_all
    g_base = g_numb;
else
    error(chkvar(g_base,{},'vector',{mfilename,'',2}));
end

% next argument is {gr_sliced}
error(chkvar(varargin{next_arg},'grouping','scalar',{mfilename,'',next_arg}));
gr_sliced = varargin{next_arg};
next_arg = next_arg + 1;

% next argument is always {g_sliced}
is_all = false;
[msg1 is_int] = chkvar(varargin{next_arg},'integer',{},{mfilename,'',next_arg});
if is_int
    g_sliced = varargin{next_arg};
else
    [msg2 is_all] = chkvar(varargin{next_arg},'char',{},{mfilename,'',2});
    if ~is_all
        error('%s\n%s',msg1,msg2);
    end
end
next_arg = next_arg + 1;

% optional additional argument
if nargin == next_arg
    [msg is_h] = chkvar(varargin{next_arg},'integer',{});   %#ok
    if is_h
        error(chkvar(varargin{next_arg},{},...
            {'scalar',{'eqlower',nohierarchies(gr_sliced)}},...
            {mfilename,'',next_arg}));
        h_sliced = varargin{next_arg};
    else
        h_sliced = 1;
    end
else
    h_sliced = 1;
end

% check consistency of {g_sliced}\
g_numb = grpidnum(gr_sliced,h_sliced);
if is_all
    g_sliced = g_numb;
else
    error(chkvar(g_sliced,{},'vector',{mfilename,'',next_arg-1}));
end

% verify that {gr_base} and {gr_sliced} contain the same number of samples
no_samples = [size(gr_base.assignment,2) size(gr_sliced.assignment,2)];
if no_samples(1) ~= no_samples(2)
    error('Number of samples in {gr_base} (%d) and {gr_sliced} (%d) are incompatible',...
        no_samples(1),no_samples(2));
end