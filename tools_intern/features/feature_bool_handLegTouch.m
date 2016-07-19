function feature = feature_bool_handLegTouch(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if any of {lfingers,rfingers} are "touching" any of the segments below {lknee,rknee,lankle,rankle}
%
% Feature value 0: Fingers not touching lower legs or feet.
% Feature value 1: Fingers touching lower legs or feet.
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

lfingers_ltibia_touch = feature_bool_distPointSegment(mot,'lknee','lankle','lfingers',thresh);
lfingers_rtibia_touch = feature_bool_distPointSegment(mot,'rknee','rankle','lfingers',thresh);
lfingers_lfoot_touch = feature_bool_distPointSegment(mot,'lankle','ltoes','lfingers',thresh*3);
lfingers_rfoot_touch = feature_bool_distPointSegment(mot,'rankle','rtoes','lfingers',thresh*3);

feature = rfingers_ltibia_touch | rfingers_rtibia_touch | rfingers_lfoot_touch | rfingers_rfoot_touch | ...
          lfingers_ltibia_touch | lfingers_rtibia_touch | lfingers_lfoot_touch | lfingers_rfoot_touch;