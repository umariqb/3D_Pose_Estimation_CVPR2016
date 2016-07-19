% constraints.jointID
% constraints.jointList
% constraints.pos
% constraints.frame
% constraints.windowsize

function mot = editMotion(skel,mot,constraints)

A = []; b = []; Aeq = []; beq = [];

lb = [];
ub = [];
for i=constraints.jointList'
    lb = [lb; skel.nodes(i).limits(:,1)];
    ub = [ub; skel.nodes(i).limits(:,2)];
end

options=optimset('Display','iter',...
                 'MaxIter', 10,...
                 'TolFun',0.1,...
                 'TolCon',0.1,...
                 'Algorithm','active-set');
                 

dofs = getDOFsFromSkel(skel);

regardedDOFs = dofs.euler(constraints.jointList);

x0 = zeros(sum(regardedDOFs),1);

frame = cutMotion(mot,constraints.frame,constraints.frame);

X = fmincon(@objfun_local,x0,A,b,Aeq,beq,lb,ub,@(x) nonlcon_local(x,constraints,regardedDOFs,skel,frame),options);

y  = [zeros(size(X,1),1) zeros(size(X,1),1) X zeros(size(X,1),1) zeros(size(X,1),1)]; 
x  = [1 2 constraints.windowsize+1 2*constraints.windowsize 2*constraints.windowsize+1];
xx = 1:2*constraints.windowsize+1;
yy = spline(x,y,xx);

eulers = cell2mat(cellfun(@(x) x(:,constraints.frame-constraints.windowsize:constraints.frame+constraints.windowsize),...
                      mot.rotationEuler(constraints.jointList),'UniformOutput',0));

eulers = eulers + yy;

eulers = mat2cell(eulers,regardedDOFs,size(eulers,2));

c=0;
for i=constraints.jointList'
    c=c+1;
    mot.rotationEuler{i}(:,constraints.frame-constraints.windowsize:constraints.frame+constraints.windowsize)=eulers{c};
end
mot = convert2quat(skel,mot);
mot.jointTrajectories = forwardKinematicsQuat(skel,mot);

end

%% local functions

function F = objfun_local(x)

S = eye(size(x,1));

F = 1/2 * x' * S * x;

end

function [c,ceq] = nonlcon_local(x,constraints,regardedDOFs,skel,frame)

    newEulers = cell2mat(frame.rotationEuler(constraints.jointList)) + x;
    frame.rotationEuler(constraints.jointList) = mat2cell(newEulers,regardedDOFs,1);
    frame = convert2quat(skel,frame);
    frame.jointTrajectories = forwardKinematicsQuat(skel,frame);
    
    ceq = frame.jointTrajectories{constraints.jointID}-constraints.pos;
    c=[];
    
end