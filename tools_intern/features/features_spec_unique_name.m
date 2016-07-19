function names = features_spec_unique_name(f)
% names = features_spec_unique_name(f)
%
% Returns a list of feature function names formed from the feature_spec_struct f.
% These names are unique in the sense that all feature_spec parameters are appended to the function name.

names = cell(length(f),1);
for k=1:length(f)
    names{k} = [f(k).name '_' num2str(f(k).win_offset_rel) '_' num2str(f(k).win_length_ms)];
    for j=1:length(f(k).params)
        if (ischar(f(k).params{j}))
            p = f(k).params{j};    
        elseif (isnumeric(f(k).params{j}))
            p = num2str(f(k).params{j});
        else
            continue;
        end
        names{k} = [names{k} '_' p];
    end
end