function feature = feature_bool_handTouch(mot,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests if wrists or fingers are "touching"
%
% Feature value 0: Wrists or fingers not touching.
% Feature value 1: Wrists or fingers touching.
%
% Parameters:
% threshold .... distance threshold, measured relative to respective hand length

if (nargin<=1)
    thresh = 1;
else
    thresh = varargin{1};
end

lfingers_rhand_touch = feature_bool_distPointSegment(mot,'rfingers','rwrist','lfingers',thresh);
lwrist_rhand_touch = feature_bool_distPointSegment(mot,'rfingers','rwrist','lwrist',thresh);
rfingers_lhand_touch = feature_bool_distPointSegment(mot,'lfingers','lwrist','rfingers',thresh);
rwrist_lhand_touch = feature_bool_distPointSegment(mot,'lfingers','lwrist','rwrist',thresh);

feature = lfingers_rhand_touch | lwrist_rhand_touch | rfingers_lhand_touch | rwrist_lhand_touch;