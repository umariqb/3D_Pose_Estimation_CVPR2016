function dofs = getDOFsFromSkel(skel)

dofs.euler = zeros(1,skel.njoints);
for i=1:skel.njoints
    dofs.euler(i) = min(3,size(skel.nodes(i).DOF,1));
end
dofs.quat(dofs.euler>0)=4;
dofs.expmap(dofs.euler>0)=3;
dofs.pos = 3*ones(1,skel.njoints);