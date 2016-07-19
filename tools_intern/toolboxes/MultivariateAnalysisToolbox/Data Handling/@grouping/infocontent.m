function [inf, inf_rel] = infocontent(varargin)

% INFOCONTENT information content of a grouping.
% -------------------------------------------------
% (1) [inf inf_rel] = infocontent(gr0, h0, gr1, h1)
% (2) [inf inf_rel] = infocontent(gr0, h0, vr)
% -------------------------------------------------
% Description: Let {vr} or alternatively the hierarchy {h1} of {gr1} stand
%              for values assigned to samples, designated by the RV {X},
%              and let the hierarchy {h0} of the grouping {gr0} be a
%              labeling of the samples, designated by the RV {Y}. The 
%              information content of {gr0} is defined as the mutual
%              entropy H(X,Y), and the relative information content is
%              defined as the information content divided by the entropy of
%              {X}, namely H(X,Y)/X(X) = 1 - H(X|Y)/H(X).
% Input:       {gr0} a grouping instance.
%              <{h0}> hierarchy level (def = 1).
%              (1) the information content is measured against another
%                  grouping.
%                  {gr1} the other grouping.
%                  <{h1}> hierarchy level of {gr1} (def=1).
%              (2) the information content is measured against a variables.
%                 {vr} the variable.
% Output:      {inf} mutual entropy H(X,Y).
%              {inf_rel} normalized mutual entropy H(X,Y)/H(X).

% © Liran Carmel
% Classification: Characteristics of grouping
% Last revision date: 02-Sep-2004

% parse input line
[gr vr] = parse_input(varargin{:});

% initialize
gid = gr.gcn2gid{1};
gs = unit(groupsize(gr),1);

% compute the entroy of {vr}
Hx = entropy(vr);

% compute the conditional entropy
cH = 0;
for ii = 1:nogroups(gr)
    samp = grp2samp(gr,gid(ii));
    vrii = variable('data',vr(samp));
    cH = cH + gs(ii)*entropy(vrii);
end

% compute the information content
inf = Hx - cH;
inf_rel = inf / Hx;

% #########################################################################
function [gr0, vr] = parse_input(varargin)

% PARSE_INPUT parses input line.
% --------------------------------
% [gr0 vr] = parse_input(varargin)
% --------------------------------
% Description: parses input line.
% Input:       {varargin} list of input parameters.
% Output:      {gr0} grouping instance.
%              {vr} variable.

% verify number of arguments
error(nargchk(2,4,nargin));

% first argument is always {gr0}
error(chkvar(varargin{1},{},'scalar',{mfilename,'',1}));
gr0 = varargin{1};

% check if second argument is {h0}
if isa(varargin{2},'double')    % {h0}
    error(chkvar(varargin{2},'integer',...
        {'scalar',{'greaterthan',0},{'eqlower',gr0.no_hierarchies}},...
        {mfilename,'',2}));
    h0 = varargin{2};
    next_arg = 3;
else
    h0 = 1;
    next_arg = 2;
end
gr0 = subgrouping(gr0,h0);

% check next argument which is either {vr} of {gr}
if isa(varargin{next_arg},'grouping')  % {gr}
    error(chkvar(varargin{next_arg},{},'scalar',{mfilename,'',next_arg}));
    gr1 = varargin{next_arg};
    h1 = 1;
    next_arg = next_arg + 1;
    if nargin == next_arg
        error(chkvar(varargin{next_arg},'integer',...
            {'scalar',{'greaterthan',0},{'eqlower',gr1.no_hierarchies}},...
            {mfilename,'',next_arg}));
        h1 = varargin{next_arg};
    end
    vr = variable(gr1(h1,:));
elseif isa(varargin{next_arg},'variable')  % {vr}
    error(chkvar(varargin{next_arg},{},'scalar',{mfilename,'',next_arg}));
    vr = varargin{next_arg};
else
    error('%s: unrecognized type',upper(inputname(2)));
end

% check consistency
if nosamples(vr) ~= nosamples(gr0)
    error('Number of Samples do not match')
end