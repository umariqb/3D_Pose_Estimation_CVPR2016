function boundingBox = computeBoundingBoxPRO(mot)

boundingBox = [inf;-inf;inf;-inf;inf;-inf];

for k = 1:mot.njoints
    if isfield(mot,'vertices')
        trajectory = mot.vertices{k};
    else
        trajectory = mot.jointTrajectories{k};
    end
    if ~isempty(trajectory)
        boundingBox(1) = min(boundingBox(1),min(trajectory(1,:))); % xmin
        boundingBox(2) = max(boundingBox(2),max(trajectory(1,:))); % xmax
        boundingBox(3) = min(boundingBox(3),min(trajectory(2,:))); % ymin
        boundingBox(4) = max(boundingBox(4),max(trajectory(2,:))); % ymax
        boundingBox(5) = min(boundingBox(5),min(trajectory(3,:))); % zmin
        boundingBox(6) = max(boundingBox(6),max(trajectory(3,:))); % zmax
    end
end