function [res,points]=findContConst(frame,skel,mot,mot_result,list,Constraints,overlap)

length=100;
dim=size(list);

% candidates=list(frame,:);
% numCand=size(candidates);
% cont=0;
% counter=1;
% while(cont==0)
%     cont=candidates(ceil(numCand(2)*rand(1)));
%     if (cont>1900)
%         length=2000-cont;
%         if(length<20)
%             cont=frame;
%         end
%     end
%     if (cont==frame)
%         cont=0;
%     end
%     counter=counter+1;
% end

cont=list(1,frame);
count=0;
distance=zeros(1,dim(1));
for trial=1:dim(1)
    if(list(trial,frame)+length<dim(2))
        mot_tmp=cutMot(skel,mot,list(trial,frame),list(trial,frame)+length);
    %     fprintf('mot_tmp: %4i - %4i\n',list(trial,frame),list(trial,frame)+length);
        mot_tmp2=appendAndBlend(skel,mot_result,mot_tmp,overlap);
        v1=-Constraints(2:4)'+mot_tmp2.rootTranslation(:,mot_tmp2.nframes);
        v2=-Constraints(2:4)'+mot_result.rootTranslation(:,mot_result.nframes);
        points(:,trial)=mot_tmp2.rootTranslation(:,mot_tmp2.nframes);
        v1=v1/(sqrt(v1'*v1));
        v2=v2/(sqrt(v2'*v2));
        distance(trial)=acos(v1'*v2);

%         fprintf('List Elem: %4i Distance %4i = %4.4f\n',list(trial,frame),trial,distance(trial));
    else
        distance(trial)=pi;
        points(:,trial)=[0 0 0];
    end
end

[distance, index]=min(distance);
cont=list(index,frame);

fprintf('Frame %4i will be continued with Frame %4i ',frame,cont);

res=cutMot(skel,mot,cont,cont+length);