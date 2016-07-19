function [mot_result] = simpleMotionBlending(skel,mot,frames,list,startframe)

overlap=10;
mot.orgFrames=1:mot.nframes;
mot_result=cutMot(skel,mot,startframe,startframe+overlap);
mot_result=moveToOrigin(skel,mot_result);


%% Code für Retrieval auf Schnipseln
% while (mot_result.nframes<frames)
%     %get new motion
%     query=getQuerySequence(mot_result,overlap);
%     mot_app=findContinuatingMotion(skel,query,DB);
%     mot_result=appendAndBlend(skel,mot_result,mot_app,overlap);
% end


%% Code für Suche mit LDM auf einer Sequenz
% while (mot_result.nframes<frames)
%     query=getLastFrame(mot_result);
%     mot_app=findCont(query,skel,mot,list);
%     mot_result=appendAndBlend(skel,mot_result,mot_app,overlap);
% end

%% Code für Suche mit LDM auf Sequenz mit Constraints.

% Define Constraints

% C = [#frame #posX #posY #posZ]

C=[0 -1000 -1000 -1000];

dist=inf;
blendings=0;
while (dist>1&&blendings<30)
    query=getLastFrame(mot_result);
    [mot_app,points(:,:,blendings+1)]=findContConst(query,skel,mot,mot_result,list,C,overlap);
    mot_result=appendAndBlend(skel,mot_result,mot_app,overlap);
    blendings=blendings+1;
    d=C(2:4)-mot_result.rootTranslation(mot_result.nframes);
    dist=sqrt(d*d');
    fprintf('Distance: %f\n',dist);
end
if (dist<1)
    fprintf('Goal reached!\n')
end
if (~blendings<500)
    fprintf('Maximum number of iterations reached!\n')
end
% figure;
% plot3(C(2),C(3),C(4),'*');
% hold all;
% plot3(0,0,0,'*');
% hold all;
% for i=1:blendings
%     help=points(:,:,i); size(help);
%     plot3(help(1,:),help(2,:),help(3,:),'+');
%     hold all;
% end

