function [ alpha, beta, gamma ] = getAngles( v1, v2 )

% XY-plane
v1proj = v1; v1proj(3) = 0;
v2proj = v2; v2proj(3) = 0;
alpha = acos( dot(v1proj, v2proj) / norm(v1proj) / norm(v2proj) );

% XZ-plane
v1proj = v1; v1proj(2) = 0;
v2proj = v2; v2proj(2) = 0;
beta = acos( dot(v1proj, v2proj) / norm(v1proj) / norm(v2proj) );

% YZ-plane
v1proj = v1; v1proj(1) = 0;
v2proj = v2; v2proj(1) = 0;
gamma = acos( dot(v1proj, v2proj) / norm(v1proj) / norm(v2proj) );
