function [ obj ] = getSensorObject(position, orientation)
scale = 0.02;
sensor = sensor3d(scale);
obj = emptyObject;
obj.type = 'object';
obj.vertices = sensor.vertices;
obj.faces = sensor.faces;
obj.faceColor = sensor.faceColor;
obj.faceVertexCData = sensor.faceVertexCData;
obj.position = position;
obj.orientation = orientation;
end

