function out = subsref(vr,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(vr,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - Used for two kinds of reference:
%                   1. regular inter-object reference
%                   2. intra-object reference, where obj(ii) is the samples
%                      {ii} of variable {obj}.
%              {} - Used only as an intra-object reference, where obj{ii}
%                   is the nonmissing samples {ii} of variable {obj}.
%              .  - field access of a (scalar) variable object.
% Input:       {vr} variable instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.
% Example:     Let {vr} is a 3-by-4 array of variables. Then
%              1. vr(2) is the (2,1) element of {vr} (the output is a
%                 variable object).
%              2. vr(2,3) is the (2,3) element of {vr} (the output is a
%                 variable object)
%              3. vr(2,1:end) is a length-4 vector of variable objects.
%              4. vr(2,3,80:end) are data element 80:end of the variable
%                 object {vr(2,3)}.
%              5. vr(2,2:end,80:end) is a 3-by-something matrix of
%                 variables-by-samples obtained from samples 80:end of the
%                 three variables {vr(2,2:end)}. Notice that if the
%                 variables have different number of samples, an error
%                 results.
%              6. vr.level is a 3-by-4 cell array of the levels of all
%                 elements in {vr}
%              7. vr(2,3).level is the level (string) of the variable
%                 object {vr(2,3)}.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 06-Feb-2006

% initialize
out = [];
dims = nodims(vr);

% standard switch
switch S(1).type
    case '()'
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = vr(S(1).subs{:});
        elseif no_indices == 1 && length(S(1).subs{1}) == 1 && ...
                S(1).subs{1} == 1 && dims == 0 && length(S) > 1
            % this tries to resolve an ambiguity that might arise when
            % calling to vr(1) when {vr} is a singelton. This ambiguity is
            % now removed in case that we call to vr(1).something. Other
            % cases are still ambiguous
            out = vr;
        else                       % intra-object indexing is required
            % extract relevant subset of variables
            vr = vr(S(1).subs{1:dims});
            % find how many variables are in the relevant subset
            no_vars = numel(vr);
            % the following corrects for the call vr(1,something) when {vr}
            % is a scalar.
            if ~dims && no_indices > 1
                dims = 1;
            end
            % see if the keyword END was used - and correct {S(1).subs{dims+1}}
            if any(S(1).subs{dims+1} < 1)
                % verify that all variables have the same no_samples
                no_samples = vr(1).no_samples;
                for jj = 2:no_vars
                    if vr(jj).no_samples ~= no_samples
                        error('Nonequal number of samples in the different variables');
                    end
                end
                S(1).subs{dims+1} = S(1).subs{dims+1} + no_samples;
            end
            % collect data into {out}
            out = [];
            for jj = 1:no_vars
                out = [out ; forcerow(vr(jj).data(S(1).subs{dims+1}))];
            end
        end
    case '{}'
        data = nanless(vr);
        out = data(S(1).subs{:});
    case '.'
        out = get(vr,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end