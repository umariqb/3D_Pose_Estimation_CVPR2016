function out = subsref(cvm,S)

% SUBSREF basic indexing method.
% --------------------
% out = subsref(cvm,S)
% --------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii,jj) is the
%                      variables {ii} versus variables {jj}. Single
%                      parameter indexing (e.g., obj(ii)) is forbiden.
%              {} - unassigned.
%              .  - field access of a single cvmatrix object.
% Input:       {cvm} covmatrix instance(s).
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 10-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % initialize
        out = [];
        dims = nodims(cvm);
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = cvm(S(1).subs{:});
        else                       % intra-object indexing is required
            % extract relevant subset of variables
            cvm = cvm(S(1).subs{1:dims});
            % currently, indexing does not support multiple objects
            error(chkvar(cvm,{},'scalar',...
                {mfilename,'Number of referred elements',0}));
            % forbeed one-parameter indexing
            if no_indices == dims + 1
                error('single indexing of a cvmatrix object is not allowed');
            end
            % see if the keyword END was used - and correct appropriate S(1).subs
            if any(S(1).subs{dims+1} < 1)
                S(1).subs{dims+1} = S(1).subs{dims+1} + cvm.vvmatrix.no_rows;
            end
            if any(S(1).subs{dims+2} < 1)
                S(1).subs{dims+2} = S(1).subs{dims+2} + cvm.vvmatrix.no_cols;
            end
            % collect output
            out = cvm.vvmatrix.matrix(S(1).subs{dims+1},S(1).subs{dims+2});
        end
    case '{}'
        error('''{}'' indexing is unsupported in CVMATRIX');
    case '.'
        out = get(cvm,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end