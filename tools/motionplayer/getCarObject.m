function car = getCarObject()
car = cell(5,1);
for i = 1 : size(car,1)
    car{i} = emptyObject();
    car{i}.type = 'object';
    position = (400:-2:-400)';
    position = [position zeros(size(position,1),2)]';
    car{i}.position = position;
    car{i}.orientation = [0.707106781186548;-0.707106781186548;0;0];
    car{i}.size = 20;
    car{i}.edgeColor = [0.3 0.3 0.3];
    car{i}.faceColor = [0.2 0.2 0.2];
end

[volvoFaces, volvoPatches] = patchRawFile(...
    fullfile('objects', 'volvo', 'volvo_car.raw'));
[volvoWFLFaces, volvoWFLPatches] = patchRawFile(...
    fullfile('objects', 'volvo', 'volvo_wfl.raw'));
[volvoWFRFaces, volvoWFRPatches] = patchRawFile(...
    fullfile('objects', 'volvo', 'volvo_wfr.raw'));
[volvoWBLFaces, volvoWBLPatches] = patchRawFile(...
    fullfile('objects', 'volvo', 'volvo_wbl.raw'));
[volvoWBRFaces, volvoWBRPatches] = patchRawFile(...
    fullfile('objects', 'volvo', 'volvo_wbr.raw'));

car{1}.name = 'volvo';
car{1}.faces = volvoPatches;
car{1}.vertices = volvoFaces;

car{2}.name = 'volvo_wheel_front_left';
car{2}.faces = volvoWFLPatches;
car{2}.vertices = volvoWFLFaces;

car{3}.name = 'volvo_wheel_front_right';
car{3}.faces = volvoWFRPatches;
car{3}.vertices = volvoWFRFaces;

car{4}.name = 'volvo_wheel_back_left';
car{4}.faces = volvoWBLPatches;
car{4}.vertices = volvoWBLFaces;

car{5}.name = 'volvo_wheel_back_right';
car{5}.faces = volvoWBRPatches;
car{5}.vertices = volvoWBRFaces;

end

