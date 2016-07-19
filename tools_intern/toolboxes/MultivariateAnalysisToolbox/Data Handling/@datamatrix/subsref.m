function out = subsref(dm,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(dm,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - unassigned.
%              {} - unassigned.
%              .  - access to the fields of a (scalar) datamatrix object.
% Input:       {dm} datamatrix instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 12-Jan-2005

% standard switch
switch S(1).type
    case '()'
        error('''()'' indexing is unsupported in DATAMATRIX');
    case '{}'
        error('''{}'' indexing is unsupported in DATAMATRIX');
    case '.'
        out = get(dm,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end