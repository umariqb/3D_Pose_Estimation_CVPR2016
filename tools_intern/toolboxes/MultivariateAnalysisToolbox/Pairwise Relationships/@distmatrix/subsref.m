function out = subsref(dstm,S)

% SUBSREF basic indexing method.
% ----------------------
% out = subsref(dstm, S)
% ----------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii,jj) is the
%                      samples {ii} versus samples {jj}. Single parameter
%                      indexing (e.g., obj(ii)) is forbiden.
%              {} - unassigned.
%              .  - field access of a single dissimatrix object.
% Input:       {dstm} distmatrix instance(s).
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 12-Jan-2005

% standard switch
switch S(1).type
    case '()'
        % initialize
        out = [];
        dims = nodims(dstm);
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = dstm(S(1).subs{:});
        elseif ~dims && no_indices == 1 && S(1).subs{:} == 1    % scalar
            out = dstm(S(1).subs{:});
        else                       % intra-object indexing is required
            % extract relevant subset of variables
            dstm = dstm(S(1).subs{1:dims});
            % currently, indexing does not support multiple objects
            error(chkvar(dstm,{},'scalar',...
                {mfilename,'Number of referred elements',0}));
            % forbeed one-parameter indexing
            if no_indices == dims + 1
                error(['single indexing of a distmatrix object ' ...
                    'is not allowed']);
            end
            % see if the keyword END was used - and correct appropriate S(1).subs
            if any(S(1).subs{dims+1} < 1)
                S(1).subs{dims+1} = S(1).subs{dims+1} + dstm.ssmatrix.no_rows;
            end
            if any(S(1).subs{dims+2} < 1)
                S(1).subs{dims+2} = S(1).subs{dims+2} + dstm.ssmatrix.no_cols;
            end
            % collect output
            out = dstm.ssmatrix.matrix(S(1).subs{dims+1},S(1).subs{dims+2});
        end
    case '{}'
        error('''{}'' indexing is unsupported in DISTMATRIX');
    case '.'
        out = get(dstm,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end