function vr = rdivide(vr1,vr2)

% RDIVIDE divides two variables
% ---------------
% vr = vr1 ./ vr2
% ---------------
% Description: Let {vr1} and {vr2} be two variables. Then vr1 ./ vr2 is
%              just like vr1(1:end) ./ vr2(1:end).
% Input:       {vr1} lefthand variable instance.
%              {vr2} righthand variable instance.
% Output:      {vr} unified variable instance.

% © Liran Carmel
% Classification: Operators
% Last revision date: 02-Sep-2004

% parse input line
error(nargchk(2,2,nargin));
error(chkvar(vr1,{},'scalar',{mfilename,inputname(1),1}));
error(chkvar(vr2,'variable','scalar',{mfilename,inputname(2),2}));
if nosamples(vr1)~=nosamples(vr2)
    error('%s and %s do not have the same number of samples',...
        inputname(1),inputname(2));
end
if isnominal(vr1) || isnominal(vr2)
    error('division is not defined for nominal variables');
end

% merge names
name = '';
len1 = length(vr1.name);
len2 = length(vr2.name);
if len1
    if len2 % both {vr1} and {vr2} have names
        if strcmp(vr1.name,vr2.name)    % the names are identical
            name = vr1.name;
        else                            % the names are different
            name = sprintf('%s ./ %s',vr1.name,vr2.name);
        end
    else    % onle {vr1} has a name
        name = vr1.name;
    end
elseif len2 % only {vr2} has a name
    name = vr2.name;
end

% merge descriptions
description = '';
len1 = length(vr1.description);
len2 = length(vr2.description);
if len1
    if len2 % both {vr1} and {vr2} have descriptions
        if strcmp(vr1.description,vr2.description)  % the descriptions are identical
            description = vr1.description;
        else                                        % the descriptions are different
            description = sprintf('%s; %s',vr1.description,vr2.description);
        end
    else    % onle {vr1} has a description
        description = vr1.description;
    end
elseif len2 % only {vr2} has a description
    description = vr2.description;
end

% merge sources
source = '';
len1 = length(vr1.source);
len2 = length(vr2.source);
if len1
    if len2 % both {vr1} and {vr2} have sources
        if strcmp(vr1.source,vr2.source)    % the sources are identical
            source = vr1.source;
        else                                % the sources are different
            source = sprintf('%s; %s',vr1.source,vr2.source);
        end
    else    % onle {vr1} has a source
        source = vr1.source;
    end
elseif len2 % only {vr2} has a source
    source = vr2.source;
end

% compute data
data = vr1.data ./ vr2.data;

% level is the lowest of their levels
levels = {'unknown','nominal','ordinal','numerical'};
level = levels{min(find(strcmp(levels,vr1.level)),...
    find(strcmp(levels,vr2.level)))};   %#ok

% update minmax
mnmx1 = pminmax(vr1);
mnmx2 = pminmax(vr2);
mnmx = minmax([mnmx1(1)./mnmx2 ; mnmx1(2)./mnmx2]);

% mean, variance, distribution are not defined
vr = variable('name',name,'description',description,'source',source,...
    'data',data,'level',level,'minmax',mnmx);