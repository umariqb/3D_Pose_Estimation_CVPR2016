function res=convert2GlobalSystems(mot)

res=mot;
res.rootTranslation=cumsum(res.rootTranslation,2);

posmat=cell2mat(res.jointTrajectories);
res.jointTrajectories=mat2cell(cumsum(posmat,2),ones(res.njoints,1)*3);

for i=2:res.nframes
    res.rotationQuat{1}(:,i)=quatmult(res.rotationQuat{1}(:,i),res.rotationQuat{1}(:,i-1));
end