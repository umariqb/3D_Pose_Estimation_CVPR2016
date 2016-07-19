function mot = getLocalSystemsQuat(mot)

jointsFromRootToRightHand=[1 12 13 14 25 26 27 28 29];

mot.localSystems{1}=mot.rotationQuat{1};
j=1;
for i=jointsFromRootToRightHand(2:end)
    mot.localSystems{i,1}=quatmult(mot.rotationQuat{i},mot.localSystems{j});
    j=i;
end