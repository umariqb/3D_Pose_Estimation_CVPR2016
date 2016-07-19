function [result, ID, name] = comp( s1, s2, fn ) % fn is for internal purposes only!
% [result, ID, name] = comp( s1, s2 )
%
%       ID:   0 = OK
%             1 = field values differ
%             2 = field not existent
%             3 = lengths of cell array differ

if nargin < 3
    fn = inputname(1);
end

if (ischar(s1) && ischar(s2))
    if strcmp(s1, s2)
        result = true;
        ID = 0;
        name = [];
    else
        result = false;
        ID = 1;
        name = fn;
    end
    
elseif (isnumeric(s1) && isnumeric(s2))
    
    if (isempty(s1) && isempty(s2))
        result = true;
        ID = 0;
        name = [];
    elseif (s1==s2)
        result = true;
        ID = 0;
        name = [];
    else
        result = false;
        ID = 1;
        name = fn;
    end
    return
elseif isstruct(s1) && isstruct(s2)
    
    fields1 = fieldnames(s1);
    fields2 = fieldnames(s2);
    
    sameFields = strcmp(sort(fields1), sort(fields2));
    if not(prod(real(sameFields)))
        result = false;
        ID = 2;
        sortedFields1 = sort(fields1);
        notSameIdx = find(sameFields==0);
        name = sortedFields1(notSameIdx(1));
        return
    end
    
    result = true;
    ID = 0;
    
    for i=1:length(fields1)
        fieldname = fields1{i};
        
        val1 = getfield(s1, fieldname);
        val2 = getfield(s2, fieldname);
        
        [result, ID, name] = comp(val1, val2, fieldname);
        
        if not(result);
            return;
        end
    end
    
elseif iscell(s1) && iscell(s2)
    
    if length(s1)~=length(s2)
        result = false;
        ID = 3;
        name = [];
        return
    end

    result = true;
    
    for i=1:length(s1)

        [result, ID, name] = comp(s1{i}, s2{i}, fn);
        if not(result);
            return;
        end
    end        
else
    error('Both input arguments have to be of the same type!');
end
