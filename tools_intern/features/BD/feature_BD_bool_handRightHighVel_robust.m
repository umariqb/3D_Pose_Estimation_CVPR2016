function bool = feature_BD_bool_handRightHighVel_robust(mot, varargin)

input_params = { 'threshold_vel1' , 'threshold_vel2' };

if( ~(nargin == 1 || nargin == 3) ) error('Wrong number of arguments.'); end


threshold_vel1 = 3.5;
threshold_vel2 = 6.5;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
bool =  features_combine_robust( feature_BD_bool_handRightHighVel( mot, threshold_vel1 ) , feature_BD_bool_handRightHighVel( mot, threshold_vel2 ) );