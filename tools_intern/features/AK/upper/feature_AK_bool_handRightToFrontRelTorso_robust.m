function bool = feature_AK_bool_handRightToFrontRelTorso_robust(mot, varargin)

input_params = { 'threshold_vel1' , 'threshold_vel2' , 'win_length_ms1' };

if( ~(nargin == 1 || nargin == 4) ) error('Wrong number of arguments.'); end


threshold_vel1 = 1.3;
threshold_vel2 = 1.8;
win_length_ms1 = 250;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
bool =  features_combine_robust( feature_AK_bool_handRightToFrontRelTorso( mot, threshold_vel1, win_length_ms1 ) , feature_AK_bool_handRightToFrontRelTorso( mot, threshold_vel2, win_length_ms1 ) );