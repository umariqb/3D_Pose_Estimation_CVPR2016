function out = subsref(gr,S)

% SUBSREF basic indexing method.
% -------------------
% out = subsref(gr,S)
% -------------------
% Description: Allows for three systems of indexing:
%              () - gr(ii,jj) means the labeling of samples {jj} of
%                   hierarchies {ii}. gr(jj) means the labeling of samples
%                   {jj} in the lowest hierarchy.
%              {} - gr{ii,jj} gives all the samples that belong to labels
%                   {jj} from hierarchies {ii}.
%              .  - field access of a single or multiple GROUPING objects.
%                   For multiple objects, {out} is a cell array with the
%                   collection of the field from all the objects.
% Input:       {gr} grouping instance.
%              {S} standard Matlab reference structure.
% Output:      {out} the output.

% © Liran Carmel
% Classification: Indexing
% Last revision date: 24-Jul-2006

% initialize
out = [];
dims = nodims(gr);

% standrad switch loop
switch S(1).type
    case '()'
        % find the number of indices
        no_indices = length(S(1).subs);
        if no_indices <= dims      % no intra-object indexing is required
            out = gr(S(1).subs{:});
        elseif no_indices == 1 && length(S(1).subs{1}) == 1 && ...
                S(1).subs{1} == 1 && dims == 0 && length(S) > 1
            % this tries to resolve an ambiguity that might arise when
            % calling to gr(1) when {gr} is a singelton. This ambiguity is
            % now removed in case that we call to gr(1).something. Other
            % cases are still ambiguous
            out = gr;
        else                       % intra-object indexing is required
            % treat the special case of a single instance called as gr(1,...)
            if no_indices == dims + 3
                error(chkvar(S(1).subs{1},{},{'match',{1}},...
                    {mfilename,'First index of grouping',0}));
                S(1).subs = {S(1).subs{2:end}};
            end
            % extract relevant subset of variables
            gr = gr(S(1).subs{1:dims});
            % find how many groupings are in the relevant subset
            no_grs = numel(gr);
            % discriminate between reference with one index and with two
            % indices
            if no_indices == dims + 1       % one-index reference
                % see if the keyword END was used - and correct {S(1).subs{dims+1}}
                if any(S(1).subs{dims+1} < 1)
                    S(1).subs{dims+1} = S(1).subs{dims+1} + no_samples;
                end
                % collect data into {out}
                out = cell(1,no_grs);
                for ii = 1:no_grs
                    out{ii} = forcerow(gr(ii).assignment(1,S(1).subs{dims+1}));
                end
            else                            % two-index reference
                % see if the keyword END was used - and correct
                if any(S(1).subs{dims+1} < 1)
                    S(1).subs{dims+1} = S(1).subs{dims+1} + gr.no_hierarchies;
                end
                if any(S(1).subs{dims+2} < 1)
                    S(1).subs{dims+2} = S(1).subs{dims+2} + no_samples;
                end
                % collect data into {out}
                out = cell(1,no_grs);
                for ii = 1:no_grs
                    % previously, there was a FORCEROW instruction here. I
                    % don't remember why, and it doesn't make sense as can
                    % be immediately seen by writting gr(1:2,1:2)
                    out{ii} = gr(ii).assignment(S(1).subs{dims+1:dims+2});
                end
            end
            % for a single instance, make {out} a non-cell element
            if no_grs == 1
                out = out{1};
            end
        end
    case '{}'
        group = S(1).subs{1};
        if length(S(1).subs) == 1
            hierarchy = 1;
        else
            hierarchy = S(1).subs{2};
            if ischar(hierarchy) && strcmp(hierarchy,':')
                hierarchy = 1:gr.no_hierarchies;
            end
        end
        % discriminate between numeric output and cell output
        [msg indic1] = chkvar(group,'numeric','scalar');    %#ok
        [msg indic2] = chkvar(hierarchy,'numeric','scalar');    %#ok
        indicator = indic1 & indic2;
        if indicator
            out = find(gr.assignment(hierarchy,:) == group);
        else
            for hh = 1:length(hierarchy)
                for gg = 1:length(group)
                    out(hh,gg) = {find(gr.assignment(hh,:) == gg)};
                end
            end
        end    
    case '.'
        out = get(gr,S(1).subs);
end

% continue with subsrefs until {S} is empty
if length(S) > 1
    out = subsref(out,S(2:end));
end