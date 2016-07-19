function [mot,frames] = loopMotion(skel,mot)

mot = fitMotion(skel,mot);

leftJoint   = 4;
rightJoint  = 9;

%finde Stellen, an denen der Fuß wechselt
%linker Fuß zuerst niedriger, dann höher als der rechte:
leftToRight=findstr([0 sign((mot.jointTrajectories{leftJoint}(1,:))-(mot.jointTrajectories{rightJoint}(1,:)))],[-1 1]);
%rechter Fuß zuerst niedriger, dann höher als der linke:
rightToLeft=findstr([0 sign((mot.jointTrajectories{rightJoint}(1,:))-(mot.jointTrajectories{leftJoint}(1,:)))],[-1 1]);

%diese Übergangsframes in eine Matrix packen:
frames = sort([leftToRight,rightToLeft]);

%finde den "mittigsten" Doppleschritt:
while numel(frames)>3
    if frames(1)<mot.nframes-frames(end)
        frames = frames(2:end);
    else
        frames = frames(1:end-1);
    end
end

quatMatrix = cell2mat(mot.rotationQuat);

mot = cutMotion(mot,frames(1),frames(end));

windowSize = ceil(mot.samplingRate/3);

q1=quatMatrix(:,frames(1)-windowSize:frames(1)+windowSize);
q2=quatMatrix(:,frames(end)-windowSize:frames(end)+windowSize);

quatMatrix = quatMatrix(:,frames(1):frames(end));

for i=1:2*windowSize+1
    
    q1(:,i)=q1(:,i)*i/(2*windowSize+1);
    q2(:,i)=q2(:,i)*(1-i/(2*windowSize+1));

end
q=q1+q2;

quatMatrix(:,1:windowSize+1)        = q(:,windowSize+1:end);
quatMatrix(:,end-windowSize:end)    = q(:,1:windowSize+1);


dofs = cell2mat(cellfun(@(x) size(x,1),mot.rotationQuat,'UniformOutput',0))';

mot.rotationQuat = mat2cell(quatMatrix,dofs,mot.nframes);

%mot.rootTranslation(:,:)=0;

mot.jointTrajectories = forwardKinematicsQuat(skel,mot);

mot.boundingBox=computeBoundingBox(mot);