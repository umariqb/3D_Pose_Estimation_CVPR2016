function [ mot ] = translateMotC3D( mot, v )

for i=1:length(mot.jointTrajectories)
    mot.jointTrajectories{i} = mot.jointTrajectories{i} + repmat(v(:), 1, mot.nframes);
end

mot.boundingBox = computeBoundingBox(mot);
