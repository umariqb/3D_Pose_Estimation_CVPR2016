function out = subsref(ft,S)

% SUBSREF basic indexing method.
% --------------------
% out = subsref(ft, S)
% --------------------
% Description: Allows for three systems of indexing:
%              () - unassigned.
%              {} - unassigned.
%              .  - field access of a (scalar) fishtrans object.
% Input:       {ft} fishtrans instance(s).
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % assume that the reference means specific lintrans instances
        out = ft(S(1).subs{:});
    case '{}'
        error('''{}'' indexing is unsupported in FISHTRANS');
    case '.'
        out = get(ft,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end