function addObjectToScene(obj)
global SCENE
% this function adds different types of 3d objects to the scene
SCENE.numObjects = SCENE.numObjects + 1;
obj.id = SCENE.numObjects;
if(~strcmp(obj.type,'label'))
    obj.boundingBox = getObjBoundingBox(obj);
end

if(obj.animated)
    SCENE.animatedObjects(size(SCENE.animatedObjects,1)+1,1) = obj.id;
    SCENE.status.nframes = max(SCENE.status.nframes,obj.nFrames);
else
    SCENE.solidObjects(size(SCENE.animatedObjects,1)+1,1) = obj.id;
end
if(isempty(obj.faceColor))
    obj.faceColor = getColorByNum(SCENE.numObjects);
end
SCENE.objects(SCENE.numObjects) = obj;
updateSceneBoundingBox;

end