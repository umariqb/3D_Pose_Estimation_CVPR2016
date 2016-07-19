function newW = convertWarpingPath(oldW)

    

    count=1;
    if oldW(end,1)~=1
%         for i=1:oldW(end,1)-1
%             newW(count,:)=[i oldW(end,2)];
%             count=count+1;
%         end

        oldW(:,1)=oldW(:,1)-(oldW(end,1)-1);
    end
    
    newW=zeros(oldW(1,1),2);
    
    for stepInd=size(oldW,1):-1:2
        if oldW(stepInd,1)==oldW(stepInd-1,1)-1
            newW(count,:)=oldW(stepInd,:);
            count=count+1;
        else
            newW(count,:)=oldW(stepInd,:);
            count=count+1;
            newW(count,1)=count;
            newW(count,2)=newW(count-1,2);
            count=count+1;
        end
    end
    newW(count,:)=oldW(1,:);
    newW=flipud(newW);
end