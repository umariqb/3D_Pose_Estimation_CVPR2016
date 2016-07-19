function res=findCont(frame,skel,mot,list)

length=50;
dim=size(list);
%%
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
%%
cont=list(2,frame);
count=3;
while(cont+length>dim(2)||abs(frame-cont)<10)
    cont=list(count,frame);
    count=count+1;
    if(count>dim(1))
        break;
    end
end

fprintf('Frame %4i will be continued with Frame %4i ',frame,cont);

res=cutMot(skel,mot,cont,cont+length);