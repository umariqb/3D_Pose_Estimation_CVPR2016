function motNew = animateMarker( skel, mot, markerName, varargin )
%   animateMarker( skel, mot, markerName, varargin )
%       
%       adds big marker to all markers given by "markerName" and then
%       calls animate(skel, mot, varargin). "markerName" can be a marker 
%       or joint name, in fact any entry of mot.namemap.

motNew = addAnimatedPatches(mot, {'params_point'}, {{markerName}}, {'point'}, {[0 0 0]}, [1], true);
if nargin > 3
    animate( skel, motNew, varargin);
else
    animate( skel, motNew);
end