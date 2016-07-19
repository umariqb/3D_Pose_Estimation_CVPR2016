function [D,w,d,theta,x0,z0] = pointCloudDTW_pos(refmot,mot,rho)
if iscell(refmot.jointTrajectories)
    refmat  = cell2mat(refmot.jointTrajectories);
else
    refmat = refmot.jointTrajectories;
end

if iscell(mot.jointTrajectories)
    mat     = cell2mat(mot.jointTrajectories);
else
    mat=mot.jointTrajectories;
end
    N       = refmot.nframes;
    M       = mot.nframes;

    d       = zeros(N,M);
    theta   = zeros(N,M);
    x0      = zeros(N,M);
    z0      = zeros(N,M);
    xt      = zeros(N,M);
    zt      = zeros(N,M);

    %fprintf('Computing point cloud cost matrix (%5i rows): %5i',N,0);
    for n=1:size(refmat,2)
        if (mod(n,10)==0) 
     %       fprintf('\b\b\b\b\b');
     %       fprintf('%5i',n); 
        end
        for m=1:size(mat,2)
            %left = rho;
            %right = rho;
            % Damit nicht auf nicht vorhandene Bereiche zugegriffen wird: 
            % n-left <1 <=> n < left + 1 <=> left > n-1 || left > m - 1
            % if ((n-left)<1 || (m-left<1)) 
            % left = min(n - 1,m - 1);
            % end
            % oder:
            % left = min(left, n-1, m-1);
            % oder:
            left = min([rho, n-1, m-1]);
            
            %while ((n-left)<1 || (m-left<1)) 
            %    left=left-1;
            %end 
            
            % (n+right)>N <=> right  > N - n
            % if ((n+right)>N || (m+right>M))
            % right = min(N - n, M - m)
            % end
            % oder:
            % right = min(right, N-n, M - m);
            % oder:
            right = min([rho, N - n, M - m]);
            % while ((n+right)>N || (m+right>M))
            %    right=right-1;
            % end
            %Abstand für alle Gelenke über max. 2 * rho Frames und optimal rotierte + translatierte Koordinaten:
            [d(n,m),theta(n,m),x0(n,m),z0(n,m),xPc,zPc,xQc,zQc] = ...
                pointCloudDistance_local(refmat(:,n-left:n+right),...
                                            mat(:,m-left:m+right));
            xt(n,m) = xQc - xPc; %Differenzen der x-Durchschnittswerte OHNE Rotation/Translation
            zt(n,m) = zQc - zPc; %Differenzen der z-Durchschnittswerte OHNE Rotation/Translation
        end
    end
   % fprintf('\n');

    % Calculation of the GDM: %Globale Distanzmatrix
    D = inf(size(d));
    D(1,:) = cumsum(d(1,:));
    D(:,1) = cumsum(d(:,1));

    for n=2:N
        for m=2:M 
            D(n,m) = d(n,m)+min([D(n-1,m),D(n-1,m-1),D(n,m-1)]);
        end
    end

    % Search for the optimal path on the GDM:
    n=N;
    m=M;
    w=[];
    w(1,:)=[N,M];
    while (n~=1 && m~=1)
        [values,number]=min([D(n-1,m-1),D(n-1,m),D(n,m-1)]);
        switch number
            case 2
                n=n-1;
            case 3
                m=m-1;
            case 1
                n=n-1;
                m=m-1;
        end
        w=[w;[n,m]];
    end
    if (n==1 && m>1) % fehlende Zurdnungen herstellen:
        w=[w;[ones(m-1,1),(m-1:-1:1)']];
    elseif (m==1 && n>1)
        w=[w;[(n-1:-1:1)',ones(n-1,1)]];
    end
end 

function [d,theta,x0,z0,xPc,zPc,xQc,zQc] = pointCloudDistance_local(P,Q)
    window_length   = size(P,2);
    njoints         = size(P,1)/3;
    K               = njoints*window_length;
    P               = reshape(P,3,K); %alle Joints und Frames hintereinander
    Q               = reshape(Q,3,K);
    [theta,x0,z0,xPc,zPc,xQc,zQc] = procrustes2D(P,Q); %Kovar-Gleicher-"Optimierung"
    d               = P - (rotmatrix(theta,'y')*Q + repmat([x0;0;z0],1,K));
    d               = 1/K*sum(d(:).^2);
end % of function pointCloudDistanceLocal