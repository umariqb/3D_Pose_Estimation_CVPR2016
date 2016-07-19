function h = createGroundPlane(bb,bb_extension,ground_tile_size)

x_min = bb(1); x_max = bb(2); z_min = bb(5); z_max = bb(6);
x_width = x_max - x_min; x_rest = mod(x_width,ground_tile_size); x_min = x_min-x_rest/2; x_max = x_max+x_rest/2; 
z_width = z_max - z_min; z_rest = mod(z_width,ground_tile_size); z_min = z_min-z_rest/2; z_max = z_max+z_rest/2; 
[floor_x,floor_z] = meshgrid(x_min:ground_tile_size:x_max,z_min:ground_tile_size:z_max);
h = surf(floor_x,repmat(bb(3)-bb_extension(3),size(floor_x)),floor_z);
nx = size(floor_x,1);
nz = size(floor_z,2);
X = zeros(nx*nz,1);
Y = zeros(nx*nz,1);
Z = zeros(nx*nz,1);
for k=1:nz
    X((k-1)*nx+1:k*nx) = floor_x(:,k);   
    Z((k-1)*nx+1:k*nx) = floor_z(:,k);
end
ntiles_x = nx - 1;
ntiles_z = nz - 1;

faces = zeros(ntiles_x*ntiles_z,4);
C = zeros(ntiles_x*ntiles_z,1);
c = zeros(1,ntiles_x); c(2:2:length(c)) = 1;
for z = 1:ntiles_z
    faces((z-1)*ntiles_x+1:z*ntiles_x,:) = (z-1)*nx + [1:ntiles_x; 2:nx; nx+2:nx+1+ntiles_x; nx+1:nx+ntiles_x]';
    C((z-1)*ntiles_x+1:z*ntiles_x) = c;
    c = 1-c;
end

% c1 = [0.5 0.5 0.5];
% c2 = [0 0 0];
%c1 = [0.75 0.75 0.75];
%c2 = [0.5 0.5 0.5];
c1 = [9.2/10 9.2/10 9.2/10];
c2 = [8/10 8/10 8/10];
Y = repmat(bb(3)-bb_extension(3),size(X));



% h = patch('Vertices',[X Y Z],...
%           'Faces',faces,...
%           'FaceVertexCData',C*c1+(1-C)*c2,...
%           'FaceColor','flat',...
%           'EdgeColor','none',...
%           'FaceLighting','none');
% set(h,'facecolor','w');
% alpha(h,0.5);
% colormap(gray);
