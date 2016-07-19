function error=feature_index_template_Skript(features);

numFeat=size(features)

for i=1:numFeat(2)
    error=features_precompute_Skript(features(i));
    create_DB_info;
    error=DB_index_precompute_Skript(features(i));
    error=motionTemplatePrecomputeBatch_skript(features(i));
end
