function out = H_rodriguesShort(in)

[m,n] = size(in);
if ((m==1) & (n==3)) | ((m==3) & (n==1)) %% it is a rotation vector
    theta = norm(in);
    if theta < eps
        R = eye(3);
    else
        if n==length(in)  in=in'; end; 	%% make it a column vec. if necess.
        omega = in/theta;
        alpha = cos(theta);
        beta = sin(theta);
        gamma = 1-cos(theta);
        omegav=[[0 -omega(3) omega(2)];[omega(3) 0 -omega(1)];[-omega(2) omega(1) 0 ]];
        A = omega*omega';        
        R = eye(3)*alpha + omegav*beta + A*gamma;        
    end;
    out = R;
else
    error('Neither a rotation matrix nor a rotation vector were provided');
end;
end

