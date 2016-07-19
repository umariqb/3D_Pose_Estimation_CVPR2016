function Q_fuzzy = motionTemplateConvertToFuzzyQuery(motionTemplate)

num_features = size(motionTemplate,1);
Q_len = size(motionTemplate,2);
Q_fuzzy = cell(1,Q_len);
for k=1:Q_len
    v = motionTemplate(:,k);
    features_select = find(v~=0.5);
    features_notselect = find(v==0.5);
    v(features_notselect) = 0;
    Q_fuzzy{k} = indicesFixedBits(num_features, features_select, v(features_select));  
end
