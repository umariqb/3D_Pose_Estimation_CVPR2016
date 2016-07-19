function gr = plus(gr1,gr2)

% PLUS joins two groups
% --------------
% gr = gr1 + gr2
% --------------
% Description: Let {gr1} and {gr2} be two grouping instances with {h1} and
%              {h2} hierarchies, respectively. Then, a new grouping
%              instance {gr} is formed that contains the union of 
%              {gr1} and {gr2}, meaning that it has {h} <= {h1} + {h2}
%              hierarchies. An inequality may occur as identical
%              grouping vectors are removed. In the later case, if the
%              identical vectors have different namings, then the new
%              naming is the concatenation of the individual namings.
%              The plus operation is symmetric in the sense that
%              {gr1}+{gr2} gives the same result (up to rearrangement of
%              strings like name, description and source) as {gr2}+{gr1}.
% Input:       {gr1} lefthand grouping instance.
%              {gr2} righthand grouping instance.
% Output:      {gr} unified grouping instance.
% Comment:     Nothing was recomputed in the new grouping (like gid2gcn,
%              gcn2gid and is_consistent). Everything was just taken from
%              {gr1} and {gr2}. The idea is to limit such calculation to
%              the constructor alone.

% © Liran Carmel
% Classification: Operations
% Last revision date: 06-Jan-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(gr1,'grouping','scalar',{mfilename,inputname(1),1}));
error(chkvar(gr2,'grouping','scalar',{mfilename,inputname(2),2}));
if (nosamples(gr1)~=nosamples(gr2)) && nosamples(gr1) && nosamples(gr2)
    error('%s and %s do not have the same number of samples',...
        inputname(1),inputname(2));
end

% merge names
name = '';
if ~strcmp(gr1.name,'unnamed')
    if ~strcmp(gr2.name,'unnamed')  % both {gr1} and {gr2} have names
        if strcmp(gr1.name,gr2.name)    % the names are identical
            name = gr1.name;
        else                            % the names are different
            name = sprintf('%s + %s',gr1.name,gr2.name);
        end
    else    % onle {gr1} has a name
        name = gr1.name;
    end
elseif ~strcmp(gr2.name,'unnamed') % only {gr2} has a name
    name = gr2.name;
else
    name = 'unnamed';
end

% merge descriptions
description = '';
len1 = length(gr1.description);
len2 = length(gr2.description);
if len1
    if len2 % both {gr1} and {gr2} have descriptions
        if strcmp(gr1.description,gr2.description)  % the descriptions are identical
            description = gr1.description;
        else                            % the names are different
            description = sprintf('%s; %s',gr1.description,gr2.description);
        end
    else    % onle {gr1} has a description
        description = gr1.description;
    end
elseif len2 % only {gr2} has a description
    description = gr2.description;
end

% merge sources
source = '';
len1 = length(gr1.source);
len2 = length(gr2.source);
if len1
    if len2 % both {gr1} and {gr2} have sources
        if strcmp(gr1.source,gr2.source)    % the sources are identical
            source = gr1.source;
        else                                % the sources are different
            source = sprintf('%s; %s',gr1.source,gr2.source);
        end
    else    % onle {gr1} has a source
        source = gr1.source;
    end
elseif len2 % only {gr2} has a source
    source = gr2.source;
end

% merge other fields
no_samples = max(gr1.no_samples,gr2.no_samples);
no_groups = [gr1.no_groups gr2.no_groups];
is_consistent = [gr1.is_consistent gr2.is_consistent];
gid2gcn = [gr1.gid2gcn gr2.gid2gcn];
gcn2gid = [gr1.gcn2gid gr2.gcn2gid];

% merge assignments and namings
assignment = [gr1.assignment ; gr2.assignment];
naming = [gr1.naming gr2.naming];

% sort according to hierarchies
idx = sorthierarchies(assignment,no_groups);

% generate the unified grouping. Cannot use the constructor here, because
% I'm not interested in further computations (consistency, etc)
gr = grouping;
gr = set(gr,'name',name,'description',description,'source',source,...
    'naming',naming(idx));
gr.assignment = assignment(idx,:);
gr.no_samples = no_samples;
gr.no_groups = no_groups(idx);
gr.is_consistent = is_consistent(idx);
gr.gid2gcn = gid2gcn(idx);
gr.gcn2gid = gcn2gid(idx);
gr.no_hierarchies = length(idx);