function out = subsref(ss,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(ss,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii) is the list
%                      (cell array) of the names of samples {ii} of
%                      sampleset {obj}.
%              .  - field access of a (scalar) sampleset object.
% Input:       {ss} sampleset instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.
% Example:     Let {ss} is a 3-by-4 array of samplesets. Then
%              1. ss(2) is the (2,1) element of {ss} (the output is a
%                 sampleset object).
%              2. ss(2,3) is the (2,3) element of {ss} (the output is a
%                 sampleset object)
%              3. ss(2,1:end) is a length-4 vector of sampleset objects.
%              4. ss(2,3,80:end) is the list of names of samples 80:end of
%                 the sampleset {ss(2,3)}.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 29-Sep-2005

% initialize
out = [];
dims = nodims(ss);

% standard switch
switch S(1).type
    case '()'
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = ss(S(1).subs{:});
        elseif no_indices == 1 && length(S(1).subs{1}) == 1 && ...
                S(1).subs{1} == 1 && dims == 0 && length(S) > 1
            % this tries to resolve an ambiguity that might arise when
            % calling to ss(1) when {ss} is a singelton. This ambiguity is
            % now removed in case that we call to ss(1).something. Other
            % cases are still ambiguous
            out = ss;
        else                       % intra-object indexing is required
            % extract relevant subset of samplesets
            ss = ss(S(1).subs{1:dims});
            % find how many samplesets are in the relevant subset
            no_ss = numel(ss);
            % the following corrects for the call ss(1,something) when {ss}
            % is a scalar.
            if ~dims && no_indices > 1
                dims = 1;
            end
            % see if the keyword END was used - and correct {S(1).subs{dims+1}}
            if any(S(1).subs{dims+1} < 1)
                % verify that all samplesets have the same no_samples
                no_samples = ss(1).no_samples;
                for jj = 2:no_ss
                    if ss(jj).no_samples ~= no_samples
                        error('Nonequal number of samples in the different samplesets');
                    end
                end
                S(1).subs{dims+1} = S(1).subs{dims+1} + no_samples;
            end
            % collect data into {out}
            out = [];
            for jj = 1:no_ss
                out = [out ss(jj).sample_names(S(1).subs{dims+1})];
            end
        end
    case '{}'
        error('{} indexing is undefined for SAMPLESET');
    case '.'
        out = get(ss,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end