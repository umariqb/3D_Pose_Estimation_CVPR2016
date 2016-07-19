function coordinateMapping = mapCoordinates(xScreen, yScreen);
x = char(xScreen);
y = char(yScreen);
 
if strfind(x, 'X') ~= 0
    coordinateMapping(1) = 1;
    if strfind(y, 'Y') ~= 0
        coordinateMapping(2) = 2;
        coordinateMapping(3) = 3;
    else
        coordinateMapping(2) = 3;
        coordinateMapping(3) = 2;
    end
elseif strfind(x, 'Y') ~= 0
    coordinateMapping(1) = 2;
    if strfind(y, 'X') ~= 0
        coordinateMapping(2) = 1;
        coordinateMapping(3) = 3;
    else
        coordinateMapping(2) = 3;
        coordinateMapping(3) = 1;
    end
elseif strfind(x, 'Z') ~= 0
    coordinateMapping(1) = 3;
    if strfind(y, 'X') ~= 0
        coordinateMapping(2) = 1;
        coordinateMapping(3) = 2;
    else
        coordinateMapping(2) = 2;
        coordinateMapping(3) = 1;
    end
end
    