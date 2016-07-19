function out = subsref(ds,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(ds,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - Used only for regular inter-object reference.
%              {} - not assigned.
%              .  - field access of a (scalar) dataset object.
% Input:       {ds} dataset instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% initialize
out = [];
dims = nodims(ds);

% standard switch
switch S(1).type
    case '()'
        if dims
            out = ds(S(1).subs{:});
        else
            error('''()'' reference to a dataset object not defined');
        end
    case '{}'
        error('''{}'' reference to a dataset object not defined');
    case '.'
        out = get(ds,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end