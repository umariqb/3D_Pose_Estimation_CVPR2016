function feature = feature_bool_handLeftAnyLegTouch(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if any of {lfingers,lwrist} are "touching" any of the segments below {lknee,rknee,lankle,rankle}
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

lfingers_ltibia_touch = feature_bool_distPointSegment(mot,'lknee','lankle','lfingers',thresh);
lfingers_rtibia_touch = feature_bool_distPointSegment(mot,'rknee','rankle','lfingers',thresh);
lfingers_lfoot_touch = feature_bool_distPointSegment(mot,'lankle','ltoes','lfingers',thresh*3);
lfingers_rfoot_touch = feature_bool_distPointSegment(mot,'rankle','rtoes','lfingers',thresh*3);

lwrist_ltibia_touch = feature_bool_distPointSegment(mot,'lknee','lankle','lwrist',thresh);
lwrist_rtibia_touch = feature_bool_distPointSegment(mot,'rknee','rankle','lwrist',thresh);
lwrist_lfoot_touch = feature_bool_distPointSegment(mot,'lankle','ltoes','lwrist',thresh*3);
lwrist_rfoot_touch = feature_bool_distPointSegment(mot,'rankle','rtoes','lwrist',thresh*3);

feature = lfingers_ltibia_touch | lfingers_rtibia_touch | lfingers_lfoot_touch | lfingers_rfoot_touch | ...
          lwrist_ltibia_touch | lwrist_rtibia_touch | lwrist_lfoot_touch | lwrist_rfoot_touch;