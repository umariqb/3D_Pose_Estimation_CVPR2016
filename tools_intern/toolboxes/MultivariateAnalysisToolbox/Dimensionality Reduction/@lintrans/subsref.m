function out = subsref(lt,S)

% SUBSREF basic indexing method.
% --------------------
% out = subsref(lt, S)
% --------------------
% Description: Allows for three systems of indexing:
%              () - unassigned.
%              {} - unassigned.
%              .  - access to the fields of a (scalar) lintrans object.
% Input:       {lt} lintrans instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % assume that the reference means specific lintrans instances
        out = lt(S(1).subs{:});
    case '{}'
        error('''{}'' indexing is unsupported in LINTRANS');
    case '.'
        out = get(lt,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end