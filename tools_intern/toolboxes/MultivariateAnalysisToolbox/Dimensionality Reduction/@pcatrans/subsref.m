function out = subsref(pt,S)

% SUBSREF basic indexing method.
% --------------------
% out = subsref(pt, S)
% --------------------
% Description: Allows for three systems of indexing:
%              () - unassigned.
%              {} - unassigned.
%              .  - field access of a (scalar) pcatrans object.
% Input:       {pt} pcatrans instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % assume that the reference means specific lintrans instances
        out = pt(S(1).subs{:});
    case '{}'
        error('''{}'' indexing is unsupported in PCATRANS');
    case '.'
        out = get(pt,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end