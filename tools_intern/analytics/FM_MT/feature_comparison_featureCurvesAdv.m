function [difference, diffPerFeature] = feature_comparison_featureCurves( filename1, filename2, constBoneLengths )

[differenceC, diffPerFeatureC] = feature_comparison_featureCurves( filename1, filename2 );
[differenceA, diffPerFeatureA] = feature_comparison_adv(filename1, filename2, true);

difference = differenceC .* differenceA;
diffPerFeature = diffPerFeatureC .* diffPerFeatureA;
