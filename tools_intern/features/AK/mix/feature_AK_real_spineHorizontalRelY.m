function feature = feature_AK_real_spineHorizontalRelY(mot)

angle = feature_angleVectorNormalPlane(mot,'root','neck',[0;1;0]);

thresh1 = [90-30, 90+30];
thresh2 = [90-20, 90+20];

f1 = angle >= thresh1(1) & angle <= thresh1(2);
f2 = angle >= thresh2(1) & angle <= thresh2(2);

% feature = features_combine_robust(f1,f2);
feature = angle;
% feature = deg2rad(angle);
