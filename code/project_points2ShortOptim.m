function [xp] = project_points2ShortOptim(X,om,T,f,c,k,alpha)

[m,n] = size(X);
%[Y,~,~] = rigid_motion(X,om,T);
Y = H_rigid_motionShort(X,om,T);
inv_Z = 1./Y(3,:);
x = (Y(1:2,:) .* (ones(2,1) * inv_Z)) ;
% Pixel coordinates:
if length(f)>1,
    xp = x .* (f * ones(1,n))  +  c*ones(1,n);
else
    xp = f * x + c*ones(1,n);
end
end
