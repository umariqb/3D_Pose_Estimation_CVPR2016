function Q = matrix2quat(M)
% Q = matrix2quat(M)
% Converts rotation matrices to unit quaternions
%
% Input:    M must be a 3x3xn array of n 3x3 rotation matrices.
%
% Output:   4xn matrix of unit quaternions represented as column vectors.
%
% Reference: Shoemake(1985)
%
% Remark:   Shoemake uses the quaternion rotation formula x' = q^{-1}xq.
%           We use the more common convention x' = qxq^{-1}. This leads to
%           transposed matrices (opposed to Shoemake's formulas), or,
%           equivalently, inverted quaternion representations.

n = size(M,3);

M11 = squeeze(M(1,1,:))';
M12 = squeeze(M(1,2,:))';
M13 = squeeze(M(1,3,:))';
M21 = squeeze(M(2,1,:))';
M22 = squeeze(M(2,2,:))';
M23 = squeeze(M(2,3,:))';
M31 = squeeze(M(3,1,:))';
M32 = squeeze(M(3,2,:))';
M33 = squeeze(M(3,3,:))';

wsq = 0.25 * (1 + M11 + M22 + M33);
wsq_gr_eps = wsq>eps;

xsq = -0.5 * (M22 + M33);
xsq_gr_eps = xsq>eps;

ysq = 0.5 * (1 - M33);
ysq_gr_eps = ysq>eps;

w  = wsq_gr_eps .*                                   sqrt(wsq);

% Der additive Term (1-wsq_gr_eps) im Nenner dient nur der Vermeidung
% von Divisionen durch Null. 
% Der Boolesche Selektionsausdruck (Vorfaktor) verhindert
% sowieso, dass der Term im Fall wsq>eps verwendet wird. Analog für die
% Nenner weiter unten.
x1  = wsq_gr_eps .*                                  (M32 - M23)./(4*(w + (1-wsq_gr_eps)));
x2_v =                                               sqrt(xsq);
x2  = (1-wsq_gr_eps).*(xsq_gr_eps).*                 x2_v;
%x3  = (1-wsq_gr_eps).*(1-xsq_gr_eps).*               0;
x   = x1+x2;

y1  = wsq_gr_eps .*                                  (M13 - M31)./(4*(w + (1-wsq_gr_eps)));
y2  = (1-wsq_gr_eps).*(xsq_gr_eps).*                 (M21 ./ (2*(x2_v + (1-xsq_gr_eps))));
y3_v =                                               sqrt(ysq);
y3  = (1-wsq_gr_eps).*(1-xsq_gr_eps).*(ysq_gr_eps).* y3_v;
%y4 = (1-wsq_gr_eps).*(1-xsq_gr_eps).*(1-ysq_gr_eps).* 0;
y   = y1+y2+y3;    

z1  = wsq_gr_eps .*                                  (M21 - M12)./(4*(w + (1-wsq_gr_eps)));
z2  = (1-wsq_gr_eps).*(xsq_gr_eps).*                 (M31 ./ (2*(x2_v + (1-xsq_gr_eps))));
z3  = (1-wsq_gr_eps).*(1-xsq_gr_eps).*(ysq_gr_eps).* (M32 ./ (2*(y3_v + (1-ysq_gr_eps))));
z4  = (1-wsq_gr_eps).*(1-xsq_gr_eps).*(1-ysq_gr_eps); % .* 1
z   = z1+z2+z3+z4;

Q = [w; x; y; z];

% remove discontinuities in quaternion path
sg = ones(1,n);
s = 1;
for i=2:n
    q1 = Q(:,i-1);
    q2 = Q(:,i);
    if (quatnormsq(q2-q1)>quatnormsq(-q2-q1))
        s = -s;
    end
    sg(i)=s;
end
Q = repmat(sg,4,1).*Q;