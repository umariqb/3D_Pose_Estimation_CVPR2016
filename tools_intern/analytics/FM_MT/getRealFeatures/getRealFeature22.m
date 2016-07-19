function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature22( mot )

scale = true;

hip_width = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1)).^2));

thresh1 = 0;
thresh2 = -0.125*hip_width;


dataReal = feature_distPointNormalPlane(mot,'lhip','rhip','lhip','rankle') - feature_distPointNormalPlane(mot,'lhip','rhip','lhip','lankle');

if nargout > 4
    dataBool = feature_AK_bool_footCrossover_robust(mot);
end