function primSphereStruct = PrimSphere(pos, size)

global SCENE
%PrimSphere(position)
%The input paramenters are: position of the sphere
%position:      [X Y Z] coordinates of the center

%resolution:    1   =>octahedron
%               1.5 => 44 faces
%               2   => 100 faces
%               2.5 => 188 faces
%               3   => 296 faces

res = SCENE.options.resolution;

color = [1 .0 .0];

res = 1 / res;
[x,y,z]=meshgrid(...
    -1-res:res:1+res, ...
    -1-res:res:1+res,...
    -1-res:res:1+res);
w=sqrt(x.^2+y.^2+z.^2);
ps=isosurface(x,y,z,w,1);

%scale object to size
ps.vertices = ps.vertices.*size;
%translate object to pos
ps.vertices = translateVertices(ps.vertices, pos);


primSphereStruct = struct(...
    'id',[],...
    'name','',...
    'type','sphere',...
    'vertices', ps.vertices,...
    'faces',ps.faces,...
    'facecolor',color,...
    'objectHandle',[]);
end