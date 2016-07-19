function jt = test_fK_Quat_frame( mot, skel, frame )

for i=1:size(mot.rotationQuat, 1)
    if ~isempty(mot.rotationQuat{i})
        rotationQuat{i} = mot.rotationQuat{i}(:, frame);
    end
end

rootTranslation = mot.rootTranslation(:, frame);

jt = fK_Quat_frame(rotationQuat, rootTranslation, skel.nodes, skel.rootRotationalOffsetQuat);