function minY = bodyMin(mot,frame)

minY = inf;
for k=1:size(mot.nameMap,1)
    if (mot.jointTrajectories{mot.nameMap{k,3}}(2,frame) < minY)
        minY = mot.jointTrajectories{mot.nameMap{k,3}}(2,frame);
    end
end
