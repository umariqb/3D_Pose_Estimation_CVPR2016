function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature3( mot )

scale = true;
neck_offset1 = 0;
neck_offset2 = -0.2;

chest_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'chest')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'neck')}(:,1)).^2));

dataReal = feature_distPointNormalPlane(mot,'chest','neck','neck','rwrist');
thresh1 = - neck_offset1 * chest_length;
thresh2 = - neck_offset2 * chest_length;

if nargout > 4
    dataBool = feature_AK_bool_handRightRaisedRelSpine_robust(mot);
end