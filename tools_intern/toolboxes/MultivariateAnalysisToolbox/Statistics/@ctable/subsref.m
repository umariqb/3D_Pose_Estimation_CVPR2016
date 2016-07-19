function out = subsref(ct,S)

% SUBSREF basic indexing method.
% --------------------
% out = subsref(ct,S)
% --------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii,jj) is the
%                      corresponding entries in the table.
%              {} - unassigned.
%              .  - field access of a single CTABLE object.
% Input:       {ct} CTABLE instance(s).
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 14-Feb-2005

% standard switch
switch S(1).type
    case '()'
        % initialize
        out = [];
        dims = nodims(ct);
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = ct(S(1).subs{:});
        else                       % intra-object indexing is required
            % extract relevant subset of variables
            ct = ct(S(1).subs{1:dims});
            % currently, indexing does not support multiple objects
            error(chkvar(ct,{},'scalar',...
                {mfilename,'Number of referred elements',0}));
            % forbeed one-parameter indexing
            if no_indices == dims + 1
                error('single indexing of a cvmatrix object is not allowed');
            end
            % see if the keyword END was used - and correct appropriate S(1).subs
            if any(S(1).subs{dims+1} < 1)
                S(1).subs{dims+1} = S(1).subs{dims+1} + ct.vvmatrix.no_rows;
            end
            if any(S(1).subs{dims+2} < 1)
                S(1).subs{dims+2} = S(1).subs{dims+2} + ct.vvmatrix.no_cols;
            end
            % collect output
            out = ct.vvmatrix.matrix(S(1).subs{dims+1},S(1).subs{dims+2});
        end
    case '{}'
        error('''{}'' indexing is unsupported in CVMATRIX');
    case '.'
        out = get(ct,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end