function [ scale, dataReal, thresh1, thresh2, dataBool ] = getRealFeature15( mot )

scale = true;

humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'relbow')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rshoulder')}(:,1)).^2));
thresh1 = 0;
thresh2 = 0.375*humerus_length;

p1 = trajectoryID(mot,'root');
p2 = trajectoryID(mot,'lhip');
p3 = trajectoryID(mot,'lankle');
q = trajectoryID(mot,'rankle');

d1 = mot.jointTrajectories{p1} - mot.jointTrajectories{p3};
d2 = mot.jointTrajectories{p2} - mot.jointTrajectories{p3}; 

n = cross(d1,d2);
n = n./repmat(sqrt(sum(n.^2)),3,1);
dataReal = dot(n,mot.jointTrajectories{q}-mot.jointTrajectories{p3});

if nargout > 4
    dataBool = feature_AK_bool_footRightBackRelLegLeft_robust(mot);
end