function features_spec = features_spec_single_func(func_name, win_offset_rel, win_length_ms, param_array)

features_spec = features_spec_struct(size(param_array,1));
for k = 1:size(param_array,1)
    features_spec(k).name = func_name;
    features_spec(k).win_offset_rel = win_offset_rel;
    features_spec(k).win_length_ms = win_length_ms;
    c = cell(1,size(param_array,2));
    for j = 1:size(param_array,2)
        c{1,j} = param_array(k,j);
    end
    features_spec(k).params = c;
end