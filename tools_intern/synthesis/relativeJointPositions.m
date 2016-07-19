function RelPos=relativeJointPositions(mot)

for i=1:mot.njoints
    RelPos(i*3-2:i*3,:)=mot.jointTrajectories{i}-mot.rootTranslation;
end