function [xp] = project_points2Short(X,om,T,f,c,k,alpha)

[m,n] = size(X);
%[Y,~,~] = rigid_motion(X,om,T);
Y = H_rigid_motionShort(X,om,T);
inv_Z = 1./Y(3,:);
x = (Y(1:2,:) .* (ones(2,1) * inv_Z)) ;
% Add distortion:
r2 = x(1,:).^2 + x(2,:).^2;
r4 = r2.^2;
r6 = r2.^3;
% Radial distortion:
cdist = 1 + k(1) * r2 + k(2) * r4 + k(5) * r6;
xd1 = x .* (ones(2,1)*cdist);
% tangential distortion:
a1 = 2.*x(1,:).*x(2,:);
a2 = r2 + 2*x(1,:).^2;
a3 = r2 + 2*x(2,:).^2;
delta_x = [k(3)*a1 + k(4)*a2 ; k(3) * a3 + k(4)*a1];
xd2 = xd1 + delta_x;
% Add Skew:
xd3 = [xd2(1,:) + alpha*xd2(2,:);xd2(2,:)];
% Pixel coordinates:
if length(f)>1,
    xp = xd3 .* (f * ones(1,n))  +  c*ones(1,n);
else
    xp = f * xd3 + c*ones(1,n);
end
end
