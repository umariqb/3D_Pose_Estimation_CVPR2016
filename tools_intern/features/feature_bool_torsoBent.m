function feature = feature_bool_torsoBent(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures whether the spine is bent towards the femurs
%
% Feature value 0: Torso upright.
% Feature value 1: Torso bent.
%

thresh = 110;

%feature = feature_distPointPlane(mot,'root','lhip','rhip','neck') + root_offset * hip_width;
angle_spine_lfemur = feature_angleSegmentSegment(mot,'neck','root','lknee','lhip');
angle_spine_rfemur = feature_angleSegmentSegment(mot,'neck','root','rknee','rhip');

feature = (angle_spine_lfemur <= thresh) & (angle_spine_rfemur <= thresh);

% figure;
% plot(angle_spine_lfemur,'red');
% hold;
% plot(angle_spine_rfemur,'blue');
