function res=getLocalPositions(mot)

res=zeros(mot.nframes,mot.njoints*3);
for i=1:mot.njoints
    res(:,i*3-2:i*3)=mot.jointTrajectories{i}-rootTranslation;
end
