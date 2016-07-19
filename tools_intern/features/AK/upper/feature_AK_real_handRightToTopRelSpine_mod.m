function real = feature_AK_real_handRightToTopRelSpine(mot, varargin)

input_params = { 'threshold_vel1' , 'win_length_ms1' };

if( ~(nargin == 1 || nargin == 3) ) error('Wrong number of arguments.'); end


threshold_vel1 = 2;
win_length_ms1 = 250;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));

femur_length = 1/2*(sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lknee')}(:,1)).^2))...
	                       + sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'rhip')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'rknee')}(:,1)).^2)));

real =  feature_velRelPointNormalPlane( mot, 'chest', 'neck', 'neck', 'rwrist', win_length_ms1 ) ./ femur_length;

% bool =  threshold_vel1* humerus_length  < feature_velRelPointNormalPlane( mot, 'chest', 'neck', 'neck', 'rwrist', win_length_ms1 );

% Anpassung an [0, 180]
real = (real+18)*180/35;
