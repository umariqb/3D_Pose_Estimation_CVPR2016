function updateSceneBoundingBox()
global SCENE
bb = [inf; -inf; inf; -inf; inf; -inf;];

for i = 1:SCENE.numObjects
    obj = SCENE.objects(i);
    bb([1,3,5]) = min(bb([1,3,5]),obj.boundingBox([1,3,5]));
    bb([2,4,6]) = max(bb([2,4,6]),obj.boundingBox([2,4,6]));
end
for i = 1:size(SCENE.armatures,2)
    obj = SCENE.armatures(i).mot;
    bb([1,3,5]) = min(bb([1,3,5]),obj.boundingBox([1,3,5]));
    bb([2,4,6]) = max(bb([2,4,6]),obj.boundingBox([2,4,6]));
end
SCENE.status.boundingBox = bb;
end