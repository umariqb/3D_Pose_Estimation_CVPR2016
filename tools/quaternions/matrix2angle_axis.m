function [phi,A] = matrix2angle_axis(M)

M11 = squeeze(M(1,1,:))';
M12 = squeeze(M(1,2,:))';
M13 = squeeze(M(1,3,:))';
M21 = squeeze(M(2,1,:))';
M22 = squeeze(M(2,2,:))';
M23 = squeeze(M(2,3,:))';
M31 = squeeze(M(3,1,:))';
M32 = squeeze(M(3,2,:))';
M33 = squeeze(M(3,3,:))';

S1 = M32 - M23;
S2 = M13 - M31;
S3 = M21 - M12;

TR = M11 + M22 + M33;

lengths = sqrt(S1.^2+S2.^2+S3.^2);
A = [S1;S2;S3]./repmat(lengths,3,1);
S = lengths/2;
C = 0.5*(TR-1);
phi = atan2(S,C);