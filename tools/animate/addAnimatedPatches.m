function mot = addAnimatedPatches(mot,function_name,function_params,varargin)
% mot,function_name,function_params,type,color,alpha,overwrite)

type = cell(length(function_name),1);
color = cell(length(function_name),1);
alpha = zeros(length(function_name),1);
overwrite = false;
for k=1:length(function_name)
    type{k} = 'disc';
    color{k} = 'blue';
    alpha(k) = 1;
end
if (nargin>6)
    overwrite = varargin{4};
end
if (nargin>5)
    alpha = varargin{3};
end
if (nargin>4)
    color = varargin{2};
end
if (nargin>3)
    type = varargin{1};
end

if (overwrite | ~isfield(mot,'animated_patch_data'))
    mot.animated_patch_data = animatedPatchStruct(length(function_name));
    k0 = 0;
else
    k0 = length(mot.animated_patch_data);
end

for k = k0+1:k0+length(function_name)
    mot.animated_patch_data(k).function_name = function_name{k-k0};
    mot.animated_patch_data(k).function_params = function_params{k-k0};
    mot.animated_patch_data(k).type = type{k-k0};
    mot.animated_patch_data(k).color = color{k-k0};
    mot.animated_patch_data(k).alpha = alpha(k-k0);
end
