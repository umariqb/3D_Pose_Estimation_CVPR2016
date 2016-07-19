function bool = feature_BD_bool_spineRotatedRight(mot, varargin)

input_params = { 'threshold_dist1' };

if( ~(nargin == 1 || nargin == 2) ) error('Wrong number of arguments.'); end


threshold_dist1 = 0.4;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));

bool =  feature_BD_distPointPlane( mot, 'rhip', 'lhip', 'neck', 'lshoulder' ) - feature_BD_distPointPlane( mot, 'rhip', 'lhip', 'neck', 'rshoulder' ) > threshold_dist1* humerus_length ;