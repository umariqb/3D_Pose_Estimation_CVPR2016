function res=convert2LocalSystems(mot)

res=mot;
% res=removeTranslation(res);
res.rootTranslation=res.rootTranslation-[[0;0;0] res.rootTranslation(:,1:end-1)];

posmat=cell2mat(res.jointTrajectories);
res.jointTrajectories=mat2cell(posmat-[zeros(res.njoints*3,1) posmat(:,1:end-1)],ones(res.njoints,1)*3);

% res=removeOrientation(skel,res);
quatinvmat=[[1;0;0;0] quatinv(res.rotationQuat{1}(:,1:end-1))];
res.rotationQuat{1}=quatmult(res.rotationQuat{1},quatinvmat);