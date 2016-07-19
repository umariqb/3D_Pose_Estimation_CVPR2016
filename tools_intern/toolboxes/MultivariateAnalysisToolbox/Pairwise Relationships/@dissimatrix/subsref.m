function out = subsref(dsm,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(dsm,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii,jj) is the
%                      samples {ii} versus samples {jj}. Single parameter
%                      indexing (e.g., obj(ii)) is forbiden.
%              {} - unassigned.
%              .  - field access of a single dissimatrix object.
% Input:       {dsm} dissimatrix instance(s).
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
        dims = nodims(dsm);
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = dsm(S(1).subs{:});
        else                       % intra-object indexing is required
            % extract relevant subset of variables
            dsm = dsm(S(1).subs{1:dims});
            % currently, indexing does not support multiple objects
            error(chkvar(dsm,{},'scalar',...
                {mfilename,'Number of referred elements',0}));
            % forbeed one-parameter indexing
            if no_indices == dims + 1
                error('single indexing of a dissimatrix object is not allowed');
            end
            % see if the keyword END was used - and correct appropriate S(1).subs
            if any(S(1).subs{dims+1} < 1)
                S(1).subs{dims+1} = S(1).subs{dims+1} + dsm.ssmatrix.no_rows;
            end
            if any(S(1).subs{dims+2} < 1)
                S(1).subs{dims+2} = S(1).subs{dims+2} + dsm.ssmatrix.no_cols;
            end
            % collect output
            out = dsm.ssmatrix.matrix(S(1).subs{dims+1},S(1).subs{dims+2});
        end
    case '{}'
        error('''{}'' indexing is unsupported in DISSIMATRIX');
    case '.'
        out = get(dsm,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end