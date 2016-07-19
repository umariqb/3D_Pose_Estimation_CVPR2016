function bool = feature_BD_bool_handRightHighVel(mot, varargin)

input_params = { 'threshold_vel1' };

if( ~(nargin == 1 || nargin == 2) ) error('Wrong number of arguments.'); end


threshold_vel1 = 6.5;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
humerus_length = sqrt(sum((mot.jointTrajectories{trajectoryID(mot,'lshoulder')}(:,1) - mot.jointTrajectories{trajectoryID(mot,'lelbow')}(:,1)).^2));

bool =  threshold_vel1* humerus_length  < feature_BD_velRelPoint( mot, 'rwrist', 'root', [] );