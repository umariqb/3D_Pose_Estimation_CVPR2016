function [tilescolor1, tilescolor2] = PrimGroundplane(varargin)
%PRIMGROUNDPLANE returns groundplane by boundingbox specs
% params: 
%   boundingbox [6x1] -> [xmin, xmax, ymin, ymax, zmin, zmax]'
%   tileSize [scalar] -> length of tiles
%   color1 [1x3], color2 [1x3] -> RGB-Values between 0 and 1
% function calls:
%   [tilesColor1, tilesColor2] = PrimGroundplane(boundingBox)
%   [tilesColor1, tilesColor2] = PrimGroundplane(boundingBox, tileSize)
%   [tilesColor1, tilesColor2] = PrimGroundplane(boundingBox, tileSize,...
%       color1, color2, alpha)
% return:
%   [tilesColor1, tilesColor2] where each argument is a struct with
%   attributes: 
%       'id',[],...
%       'name','',...
%       'type','groundplane',...
%       'vertices', vertices,...
%       'faces',col1f,...
%       'facecolor',color1,...
%       'objectHandle',[]);

boundingBox = varargin{1};
xmin = boundingBox(1);
xmax = boundingBox(2);
zmin = boundingBox(5);
zmax = boundingBox(6);
if(size(varargin,2) == 1)
    tilesize = 20;
    color1 = [.7 .7 .7];
    color2 = [1 1 1];
elseif(size(varargin,2) == 2)
    tilesize = varargin{2};
elseif(size(varargin,2) == 5)
    tilesize = varargin{2};
    color1 = varargin{3};
    color2 = varargin{4};
    alpha = varargin{5};
end

if(abs(xmin - xmax) <= tilesize)
    xmin = xmin - 1;
    xmax = xmax + 1;
    tilesize = 1;
end
if(abs(zmin - zmax) <= tilesize)
    zmin = zmin - 1;
    zmax = zmax + 1;
    tilesize = 1;
end

translationOffset = [xmin .0 zmin];

planelength = abs(xmin - xmax);
planewidth = abs(zmin - zmax);

xnumtiles = floor(planelength / tilesize);
znumtiles = floor(planewidth / tilesize);
% xoverhead = planelength - (xnumtiles * tilesize);
% zoverhead = planewidth - (znumtiles * tilesize);

xvert = [0:tilesize:xnumtiles*tilesize, planelength];
zvert = [0:tilesize:znumtiles*tilesize, planewidth];
numfaces = (xnumtiles+1)*(znumtiles+1);
%tilesperrow = xnumtiles + 1;
tilespercol = znumtiles + 1;
vertices = [[];[]];
faces = zeros(numfaces,4);

v = 1;
for i = 1:length(xvert)
    for j = 1:length(zvert)
        vertices(v,:) = [xvert(i),0,zvert(j)];
        v = v + 1;
    end
end

tiles = [];
t = 1;
for i = 1:length(xvert) * length(zvert)
    if(t>numfaces)
        break;
    end
    if(mod(i,tilespercol+1)~=0)
        tiles(t) = i;
        t = t+1;
    end
end

for f = 1:length(tiles)
    v = tiles(f);
    faces(f,:) = [v,v+1,v+tilespercol+2,v+tilespercol+1];
end

%begin with color1 for the first tile then alternating with color2
l = true;
c = true;
pointercol1f = 1;
pointercol2f = 1;
for i = 1:length(faces)
    if(mod(i,tilespercol) == 0)
        if(c == true)
            c = ~c;
            col1f(pointercol1f,:) = faces([i],:);
            pointercol1f = pointercol1f + 1;
        else
            c = ~c;
            col2f(pointercol2f,:) = [faces([i],:)];
            pointercol2f = pointercol2f + 1;
        end
        if(l == true)
            l = false;
            c = false;
        else
            l = true;
            c = true;
        end
    else
        if(c == true)
            c = ~c;
            col1f(pointercol1f,:) = faces([i],:);
            pointercol1f = pointercol1f + 1;
        else
            c = ~c;
            col2f(pointercol2f,:) = [faces([i],:)];
            pointercol2f = pointercol2f + 1;
        end
    end
    
end

%translate plane by the translationOffset
for i = 1:length(vertices)
    vertices(i,:) = vertices(i,:) + translationOffset;
end
tilescolor1 = emptyObject();
tilescolor1.name = 'groundplane1';
tilescolor1.vertices = vertices;
tilescolor1.faces = col1f;
tilescolor1.faceColor = color1;
tilescolor1.faceAlpha = alpha;

tilescolor2 = emptyObject();
tilescolor2.name = 'groundplane2';
tilescolor2.vertices = vertices;
tilescolor2.faces = col2f;
tilescolor2.faceColor = color2;
tilescolor2.faceAlpha = alpha;

end
