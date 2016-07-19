function x = spheric4d2euclid4d(r,alpha,beta,gamma)

x=zeros(4,size(r,2));
x(1,:) = r.*cos(alpha).*cos(beta).*cos(gamma);
x(2,:) = r.*sin(alpha).*cos(beta).*cos(gamma);
x(3,:) = r.*sin(beta).*cos(gamma);
x(4,:) = r.*sin(gamma);