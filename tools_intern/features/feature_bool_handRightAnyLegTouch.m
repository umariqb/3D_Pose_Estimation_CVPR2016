function feature = feature_bool_handRightAnyLegTouch(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if any of {rfingers,rwrist} are "touching" any of the segments below {lknee,rknee,lankle,rankle}
%
% Feature value 0: Hand not touching lower legs or feet.
% Feature value 1: Hand touching lower legs or feet.
%
% Parameters:
% thresh .... distance threshold, measured relative to tibia length

if (nargin<=1)
    thresh = 0.5;
else
    thresh = varargin{1};
end
 
rfingers_ltibia_touch = feature_bool_distPointSegment(mot,'lknee','lankle','rfingers',thresh);
rfingers_rtibia_touch = feature_bool_distPointSegment(mot,'rknee','rankle','rfingers',thresh);
rfingers_lfoot_touch = feature_bool_distPointSegment(mot,'lankle','ltoes','rfingers',thresh*3);
rfingers_rfoot_touch = feature_bool_distPointSegment(mot,'rankle','rtoes','rfingers',thresh*3);

rwrist_ltibia_touch = feature_bool_distPointSegment(mot,'lknee','lankle','rwrist',thresh);
rwrist_rtibia_touch = feature_bool_distPointSegment(mot,'rknee','rankle','rwrist',thresh);
rwrist_lfoot_touch = feature_bool_distPointSegment(mot,'lankle','ltoes','rwrist',thresh*3);
rwrist_rfoot_touch = feature_bool_distPointSegment(mot,'rankle','rtoes','rwrist',thresh*3);

feature = rfingers_ltibia_touch | rfingers_rtibia_touch | rfingers_lfoot_touch | rfingers_rfoot_touch | ...
          rwrist_ltibia_touch | rwrist_rtibia_touch | rwrist_lfoot_touch | rwrist_rfoot_touch;