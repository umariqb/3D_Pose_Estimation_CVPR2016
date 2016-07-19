function computeBoundingBoxSCENE()

global SCENE;

 SCENE.boundingBox = [-10;10;-10;10;-10;10]; % in cm

for m=1:SCENE.nmots
    SCENE.boundingBox([1,3,5]) = min(SCENE.boundingBox([1,3,5]),SCENE.mots{m}.boundingBox([1,3,5]));
    SCENE.boundingBox([2,4,6]) = max(SCENE.boundingBox([2,4,6]),SCENE.mots{m}.boundingBox([2,4,6]));
end
if ~isempty(SCENE.objects)
    

    
    objects = fieldnames(SCENE.objects);
    nrOfObj = numel(objects);
    for m=1:nrOfObj
        for m2=1:SCENE.objects.(objects{m}).counter
            SCENE.boundingBox([1,3,5]) = min(SCENE.boundingBox([1,3,5]),SCENE.objects.(objects{m}).boundingBox{m2}([1,3,5]));
            SCENE.boundingBox([2,4,6]) = max(SCENE.boundingBox([2,4,6]),SCENE.objects.(objects{m}).boundingBox{m2}([2,4,6]));
        end
    end
    if isinf(SCENE.boundingBox(1))
        SCENE.boundingBox = [-100;100;-100;100;-100;100]; % in cm
    end
end