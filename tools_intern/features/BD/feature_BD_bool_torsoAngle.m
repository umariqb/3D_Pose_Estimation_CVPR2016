function bool = feature_BD_bool_torsoAngle(mot, varargin)

input_params = { 'threshold_angle1' };

if( ~(nargin == 1 || nargin == 2) ) error('Wrong number of arguments.'); end


threshold_angle1 = 120;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
bool =  feature_BD_angleSegmentSegment( mot, 'neck', 'root', 'lknee', 'lhip' ) < threshold_angle1 & feature_BD_angleSegmentSegment( mot, 'neck', 'root', 'rknee', 'rhip' ) < threshold_angle1;