function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature37( mot )

scale = true;

tibia_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rankle')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2));
femur_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1)).^2));
belly_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'root')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'belly')}(:,1)).^2));
chest_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'belly')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'chest')}(:,1)).^2));
neck_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'chest')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'neck')}(:,1)).^2));
head_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'neck')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'head')}(:,1)).^2));
headtop_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'head')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'headtop')}(:,1)).^2));

body_length = tibia_length+femur_length+belly_length+chest_length+neck_length+head_length+headtop_length;

bmin = feature_YBodyMin(mot);
bmax = feature_YBodyMax(mot);

dataReal = bmax-bmin;

thresh1 = 0.9*body_length;
thresh2 = 0.8*body_length;

if nargout > 4
    dataBool = feature_AK_bool_bodyExtentRelY_robust(mot);
end