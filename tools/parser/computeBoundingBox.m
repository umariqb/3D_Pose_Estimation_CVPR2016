function boundingBox = computeBoundingBox(mot)

boundingBox = [inf;-inf;inf;-inf;inf;-inf];

if iscell(mot.jointTrajectories)
for k = 1:mot.njoints
    trajectory = mot.jointTrajectories{k};
	boundingBox(1) = min(boundingBox(1),min(trajectory(1,:))); % xmin
	boundingBox(2) = max(boundingBox(2),max(trajectory(1,:))); % xmax
	boundingBox(3) = min(boundingBox(3),min(trajectory(2,:))); % ymin
	boundingBox(4) = max(boundingBox(4),max(trajectory(2,:))); % ymax
	boundingBox(5) = min(boundingBox(5),min(trajectory(3,:))); % zmin
	boundingBox(6) = max(boundingBox(6),max(trajectory(3,:))); % zmax
end
else
    boundingBox(1) = min(min(mot.jointTrajectories(1:3:end,:))); % xmin
	boundingBox(2) = max(max(mot.jointTrajectories(1:3:end,:))); % xmax
	boundingBox(3) = min(min(mot.jointTrajectories(2:3:end,:))); % ymin
	boundingBox(4) = max(max(mot.jointTrajectories(2:3:end,:))); % ymax
	boundingBox(5) = min(min(mot.jointTrajectories(3:3:end,:))); % zmin
	boundingBox(6) = max(max(mot.jointTrajectories(3:3:end,:))); % zmax
end