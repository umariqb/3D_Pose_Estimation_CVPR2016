function motOut = filterMot(skel,mot,w,method)
motOut = mot;
for k=mot.animated(2:end)
    switch (lower(method))
        case 'r4'
        motOut.rotationQuat{k} = filterR4(w,mot.rotationQuat{k},1,'sym');
        case 's3'
        b = orientationFilter(w);
        motOut.rotationQuat{k} = filterS3(b,mot.rotationQuat{k},'sym');
        case 'sphericalaverage'
        motOut.rotationQuat{k} = filterSphericalAverageA1(w,mot.rotationQuat{k},1,'sym');
    end        
end
motOut.jointTrajectories=[];
motOut.jointTrajectories = forwardKinematicsQuat(skel,motOut);
motOut.boundingBox = computeBoundingBox(motOut);