function out = subsref(gr,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(gr,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - not assigned.
%              {} - not assigned.
%              .  - access to the fields of a (scalar) graph object.
% Input:       {gr} GRAPH instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % assume that the reference means specific graph instances
        out = gr(S(1).subs{:});
    case '{}'
        error('''{}'' indexing is unsupported in GRAPH');
    case '.'
        out = get(gr,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end