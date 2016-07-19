function computeGroundPlane(boundingBox)

global SCENE;

% xmin = -1500;
% xmax =  1500;
% zmin = -1500;
% zmax =  1500;

xmin = boundingBox(1);
xmax = boundingBox(2);
zmin = boundingBox(5);
zmax = boundingBox(6);

x_marks = xmin:SCENE.groundPlaneSquareSize:xmax;
if x_marks(end)~=xmax, x_marks = [x_marks xmax]; end
z_marks = zmin:SCENE.groundPlaneSquareSize:zmax;
if z_marks(end)~=zmax, z_marks = [z_marks zmax]; end

[x,z] = meshgrid(x_marks,z_marks);

vertices    = [x(:) zeros(numel(x),1) z(:)];
vertIDs     = reshape(1:size(vertices,1),size(x));

nfaces_x    = size(vertIDs,1)-1;
nfaces_z    = size(vertIDs,2)-1;

faces       = zeros(nfaces_x*nfaces_z,4);
cData       = zeros(nfaces_x*nfaces_z,3);

ncolors     = size(SCENE.colors.groundPlane,1);

f=0;
for i=1:nfaces_x
    id=mod(i,ncolors)+1;
    for j=1:nfaces_z
        f=f+1;
        faces(f,:) = [vertIDs(i,j) vertIDs(i+1,j) vertIDs(i+1,j+1) vertIDs(i,j+1)];
        cData(f,:) = SCENE.colors.groundPlane(mod(id+j,ncolors)+1,:);
    end
end

if ishandle(SCENE.handles.groundPlane)
    if size(cData,1)==1
        set(SCENE.handles.groundPlane,'Vertices',vertices,'Faces',faces,'FaceColor',cData);
    else
        set(SCENE.handles.groundPlane,'Vertices',vertices,'Faces',faces,'FaceColor','flat','FaceVertexCData',cData);
    end
else
    if size(cData,1)==1
        SCENE.handles.groundPlane = patch('Vertices',vertices,'Faces',faces,'FaceColor',cData,'FaceAlpha',SCENE.colors.groundPlane_FaceAlpha,'EdgeColor','none');
    else
        SCENE.handles.groundPlane = patch('Vertices',vertices,'Faces',faces,'FaceColor','flat','FaceAlpha',SCENE.colors.groundPlane_FaceAlpha,'FaceVertexCData',cData,'EdgeColor','none');
    end
end