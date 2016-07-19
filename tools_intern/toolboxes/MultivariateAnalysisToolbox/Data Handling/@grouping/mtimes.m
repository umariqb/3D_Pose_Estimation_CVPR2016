function gr = mtimes(gr1,gr2)

% MTIMES forms a "super-grouping" out of two groupings.
% --------------
% gr = gr1 * gr2
% --------------
% Description: Let {gr1} and {gr2} be two groupings, and let {h1} and
%              {h2} be any two hierarchies of {gr1} and {gr2},
%              respectively. Let {n1} and {n2} be the number of groups in
%              {h1} and {h2}, respectively. Then, a new grouping instance
%              {gr} is formed, with a hierarchy {h} that contains at most
%              {n1}*{n2} groups, which are the "outer product" of the
%              groups in {h1} and {h2}. The GIDs are assigned arbitrarily
%              using consecutive indices. This is repeated for each pair of
%              hierarchies in {gr1} and {gr2}, so that if there are {d1}
%              and {d2} hierarchies in {gr1} and {gr2}, then {gr} would
%              have {d1}*{d2} hierarchies. Name, description and source are
%              comprised from the corresponding individual fields.
% Input:       {gr1} lefthand grouping instance.
%              {gr2} righthand grouping instance.
% Output:      {gr} multiplied grouping instance.

% © Liran Carmel
% Classification: Operations
% Last revision date: 16-Feb-2005

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(gr1,'grouping','scalar',{mfilename,inputname(1),1}));
error(chkvar(gr2,'grouping','scalar',{mfilename,inputname(2),2}));

% "multiplication by zero" returns zero
if ~nosamples(gr1) || ~nosamples(gr2)
    gr = grouping;
    return;
end

% check consistency
no_samples = nosamples(gr1);
if no_samples ~= nosamples(gr2)
    error('%s and %s do not have the same number of samples',...
        inputname(1),inputname(2));
end

% merge names
name = '';
len1 = length(gr1.name);
len2 = length(gr2.name);
if len1
    if len2 % both {gr1} and {gr2} have names
        if strcmp(gr1.name,gr2.name)    % the names are identical
            name = gr1.name;
        else                            % the names are different
            name = sprintf('%s * %s',gr1.name,gr2.name);
        end
    else    % onle {gr1} has a name
        name = gr1.name;
    end
elseif len2 % only {gr2} has a name
    name = gr2.name;
end

% merge descriptions
description = '';
len1 = length(gr1.description);
len2 = length(gr2.description);
if len1
    if len2 % both {gr1} and {gr2} have descriptions
        if strcmp(gr1.description,gr2.description)  % the descriptions are identical
            description = gr1.description;
        else                            % the descriptions are different
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

% initialize
gr = grouping;

% double-loop on hierarchies
for h1 = 1:nohierarchies(gr1)
    for h2 = 1:nohierarchies(gr2)
        assg = zeros(1,no_samples);
        naming = {};
        grp = 0;
        % double-loop on groups
        for gid1 = gr1.gcn2gid{h1}
            samp1 = grp2samp(gr1,gid1,h1);
            for gid2 = gr2.gcn2gid{h2}
                common_samp = intersect(samp1,grp2samp(gr2,gid2,h2));
                % if the intersection exists - this is a new group in {gr}
                if ~isempty(common_samp)
                    grp = grp + 1;
                    assg(common_samp) = grp;
                    new_name = sprintf('%s; %s',...
                        gr1.naming{h1}{gr1.gid2gcn{h1}(gid1)},...
                        gr2.naming{h2}{gr2.gid2gcn{h2}(gid2)});
                    naming = [naming {new_name}];
                end
            end % for loop on g2
        end % for loop on g1
        gr = gr + grouping(assg,naming);
    end % for loop on h2
end % for loop on h1

% set other required fields
gr = set(gr,'name',name,'description',description,'source',source);