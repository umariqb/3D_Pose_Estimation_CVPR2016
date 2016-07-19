function bool = feature_AK_bool_shouldersRotatedLeftRelHip_robust(mot, varargin)

input_params = { 'threshold_dist1' , 'threshold_dist2' };

if( ~(nargin == 1 || nargin == 3) ) error('Wrong number of arguments.'); end


threshold_dist1 = 0.35;
threshold_dist2 = 0.40;
for i = 1:length(varargin);
    if(~isempty(varargin{i})) 
        eval([input_params{i} ' = varargin{i};']) ;
    end 
end 
bool =  features_combine_robust( feature_AK_bool_shouldersRotatedLeftRelHip( mot, threshold_dist1 ) , feature_AK_bool_shouldersRotatedLeftRelHip( mot, threshold_dist2 ) );