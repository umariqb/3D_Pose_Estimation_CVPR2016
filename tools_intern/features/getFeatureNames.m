function feature_names = getFeatureNames

load('features_spec');
range = [70:83 58:69 84:96];
fspec = features_spec(range);
feature_names = {fspec.name}';