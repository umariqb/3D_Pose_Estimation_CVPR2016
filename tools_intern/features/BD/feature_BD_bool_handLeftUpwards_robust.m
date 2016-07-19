function bool = feature_BD_bool_handLeftUpwards_robust(mot, varargin)

input_params = { 'threshold_vel1' , 'threshold_vel2' , 'win_length_ms1' };

if( ~(nargin == 1 || nargin == 4) ) error('Wrong number of arguments.'); end


threshold_vel1 = 1;
threshold_vel2 = 3;
win_length_ms1 = 250;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
bool =  features_combine_robust( feature_BD_bool_handLeftUpwards( mot, threshold_vel1, win_length_ms1 ) , feature_BD_bool_handLeftUpwards( mot, threshold_vel2, win_length_ms1 ) );