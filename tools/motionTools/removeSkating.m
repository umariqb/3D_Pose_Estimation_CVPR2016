% function removeSkating
% performs simple (naive) clean up of skating effects 
% mot = removeSkating(skel,mot)
% author: Jochen Tautges (tautges@cs.uni-bonn.de)

function mot = removeSkating(skel,mot)

leftJoint   = 4;
rightJoint  = 7;

badTranslation=0;
for i=2:mot.nframes
    if mot.jointTrajectories{leftJoint}(2,i)<=mot.jointTrajectories{rightJoint}(2,i) % left foot on floor
        joint = leftJoint;
    else
        joint = rightJoint;
    end
    badTranslation = badTranslation + mot.jointTrajectories{joint}([1,3],i)...
                                    - mot.jointTrajectories{joint}([1,3],i-1);
    mot.rootTranslation([1,3],i) = mot.rootTranslation([1,3],i) - badTranslation;
end

pos     = cell2mat(mot.jointTrajectories([leftJoint,rightJoint]));
minY    = min(min(pos(2:3:end,:)));

mot.rootTranslation(2,:) = mot.rootTranslation(2,:)-minY;

mot.jointTrajectories   = forwardKinematicsQuat(skel,mot);
mot.boundingBox         = computeBoundingBox(mot);