function d = distJointPositions(P,Q)

	n = size(P,2);
	w = [1 .5 1 1 .1 .5 1 1 .1 .2 .2 .2 .1 .1 .5 1 1 .1 .5 1 1 .1]; 

	Px=P(1,:);
	Pz=P(3,:);
	weighted_Px = sum(w.*Px);
	weighted_Pz = sum(w.*Pz);
	
	Qx=Q(1,:);
	Qz=Q(3,:);
	weighted_Qx = sum(w.*Qx);
	weighted_Qz = sum(w.*Qz);
	weight_sum = sum(w);
	
	numerator = sum(w.*(Px.*Qz - Qx.*Pz)) - (weighted_Px*weighted_Qz - weighted_Qx*weighted_Pz)/weight_sum;

	denominator = sum(w.*(Px.*Qx + Pz.*Qz)) - (weighted_Px*weighted_Qx + weighted_Pz*weighted_Qz)/weight_sum;
	theta = atan(numerator/denominator);
	
	x0 = (weighted_Px - weighted_Qx*cos(theta) - weighted_Qz*sin(theta))/weight_sum;
	
	z0 = (weighted_Pz + weighted_Qx*sin(theta) - weighted_Qz*cos(theta))/weight_sum;
	
	%rot = rotmatrix(theta,'y');
	
 	x0_matrix = [ones(1,n)*x0; zeros(2,n)];
 	z0_matrix = [zeros(2,n); ones(1,n)*z0];
	adjusted_Q = RotateY(Q,theta) + x0_matrix + z0_matrix;  
	
	d = sum(w.*sum((P-adjusted_Q).^2));
	
	