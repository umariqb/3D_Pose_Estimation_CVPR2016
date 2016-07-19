function phi = directedAngle(v1,v2)
% phi = directedAngle(v1,v2)
% returns the phi \in [0,2pi], the directed angle between 2D-vectors v1 and v2

if (size(v1,1)~=2 || size(v2,1)~=2)
    warning('Input vectors must be 2D. Returning default value.');
    phi = 0;
    return;
end

N = size(v1,2);

norm_v1 = sqrt(sum(v1.^2));
norm_v2 = sqrt(sum(v2.^2));

nv1 = [-v1(2,:);v1(1,:)];
c_v1_v2 = dot(v1,v2)./(norm_v1.*norm_v2);
c_v2_nv1 = dot(v2,nv1)./(norm_v1.*norm_v2);

% Die Winkel liegen zwischen 0 und PI, der Cosinus ist dort streng monoton fallend.
% => kleinerer Cosinus bedeutet größerer Winkel; insbesondere: cos x < 0 <=> x > PI/2

phi = zeros(1,N);

phi(c_v2_nv1 < 0) =	2 * pi - acos(c_v1_v2(c_v2_nv1 < 0));
phi(c_v2_nv1 >= 0) = acos(c_v1_v2(c_v2_nv1 >= 0));

% if (c_v2_nv1 < 0)	% acos(c_v2_nv1) > PI/2 ?
% 	phi = 2 * pi - acos(c_v1_v2);
% else 
%     phi = acos(c_v1_v2);
% end